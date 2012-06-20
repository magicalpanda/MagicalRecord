//
//  MRFactoryObject.m
//  MagicalRecord
//
//  Created by Saul Mora on 6/18/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <objc/runtime.h>
#import "MRFactoryObject.h"
#import "MRFactoryObjectSelectorCaptureObject.h"


@interface MRFactoryObject ()

@property (nonatomic, copy, readwrite) NSString *alias;
@property (nonatomic, assign, readwrite) Class factoryClass;
@property (nonatomic, strong, readwrite) NSMutableArray *buildActions;
@property (nonatomic, assign, readwrite) BOOL generateOnNextAccess;
@property (nonatomic, strong, readwrite) NSSet *associatedFactories;

@property (nonatomic, strong, readwrite) id cachedValue;
@property (nonatomic, copy, readwrite) MRFactoryObjectSequenceBuildAction cachedSequence;
@property (nonatomic, strong, readwrite) MRFactoryObjectSelectorCaptureObject *selectorCapturer;

- (void) completeSelectorCapture;

@end


@implementation MRFactoryObject

- (id) init;
{
    @throw [NSException exceptionWithName:@"Initialization Exception" reason:@"Cannot define a factory without a class" userInfo:nil];
}

- (id) initWithClass:(Class)klass;
{
    self = [super init];
    if (self)
    {
        self.factoryClass = klass;
        self.buildActions = [NSMutableArray array];
        self.associatedFactories = [NSMutableSet set];
        self.generateOnNextAccess = NO;
    }
    return self;
}

- (id) initWithClass:(Class)klass as:(NSString *)alias;
{
    self = [self initWithClass:klass];
    if (self)
    {
        self.alias = alias;
    }
    return self;
}

+ (id) factoryWithClass:(Class)klass;
{
    return [[self alloc] initWithClass:klass];
}

+ (id) factoryWithClass:(Class)klass as:(NSString *)alias;
{
    return [[self alloc] initWithClass:klass as:alias];
}

- (NSArray *) actions;
{
    return [NSArray arrayWithArray:self.buildActions];
}

- (id) setValue:(id)value;
{
    self.cachedValue = value;
    return self;
}

- (id) setSequence:(MRFactoryObjectSequenceBuildAction)sequence;
{
    self.cachedSequence = sequence;
    return self;
}

- (id) forProperty;
{
//    if (self.cachedValue == nil)
//    {
//        return nil;
//    }
    return self.selectorCapturer = [MRFactoryObjectSelectorCaptureObject capturerWithFactory:self];
}

- (void) completeSelectorCapture;
{
    NSString *propertyName = NSStringFromSelector(self.selectorCapturer.capturedSelector);
    
    //bleh, if statments...clean this up!
    if (self.cachedValue)
    {
        [self setValue:self.cachedValue forPropertyNamed:propertyName];
        self.cachedValue = nil;
    }
    if (self.cachedSequence)
    {
        [self setSequenceAction:self.cachedSequence forPropertyNamed:propertyName];
        self.cachedSequence = nil;
    }
    self.selectorCapturer = nil;
}

- (void) setValue:(id)value forPropertyNamed:(NSString *)propertyName;
{
    __weak id weakValue = value;
    MRFactoryObjectBuildAction action = ^id(MRFactoryObject *obj)
    {
        return weakValue;
    };
    [self setAction:action forPropertyNamed:propertyName];
}

- (void) setAction:(MRFactoryObjectBuildAction)action forPropertyNamed:(NSString *)propertyName;
{
    BOOL hasProperty = [self.factoryClass instancesRespondToSelector:NSSelectorFromString(propertyName)];
    if (!hasProperty)
    {
        NSString *messsage = [NSString stringWithFormat:@"Cannot define an action on a property that does not exist on %@", NSStringFromClass(self.factoryClass)];
        @throw [NSException exceptionWithName:@"Builder Property Exception" reason:messsage userInfo:nil];
    }
    [self.buildActions addObject:@{ @"propertyName" : propertyName,  @"action": action }];
}

- (void) setSequenceAction:(MRFactoryObjectSequenceBuildAction)action forPropertyNamed:(NSString *)propertyName withStartingIndex:(NSUInteger)startIndex;
{
    __weak id weakSelf = self;
    __block NSUInteger index = startIndex;
    
    MRFactoryObjectBuildAction sequenceActionWrapper = ^id(MRFactoryObject *obj){
        
        id returnValue = nil;
        if (action)
        {
            if ([weakSelf generateOnNextAccess])
            {
                index++;
                [weakSelf setGenerateOnNextAccess:NO];
            }
            returnValue = action(weakSelf, index);
        }
        return returnValue;
    };
    
    [self.buildActions addObject:@{ @"propertyName" : propertyName, @"action" : sequenceActionWrapper }];
}

- (void) setSequenceAction:(MRFactoryObjectSequenceBuildAction)action forPropertyNamed:(NSString *)propertyName;
{
    [self setSequenceAction:action forPropertyNamed:propertyName withStartingIndex:1];
}

- (id) associatedFactoryForClass:(Class)klass;
{
    NSPredicate *associationSearch = [NSPredicate predicateWithFormat:@"class = %@", klass];
    id associatedFactory = [[self.associatedFactories filteredSetUsingPredicate:associationSearch] anyObject];

    if (associatedFactory == nil)
    {
        //grab from global factory registry?
    }
    return associatedFactory;
}

- (void) setAssociation:(Class)klass forPropertyNamed:(NSString *)propertyName;
{
    id associatedFactory = [self associatedFactoryForClass:klass];
    
    [self.buildActions addObject:@{ @"propertyName" : propertyName, @"association" : associatedFactory }];
}

- (MRFactoryObjectBuildAction) actionForPropertyName:(NSString *)propertyName;
{
    NSPredicate *actionSearch = [NSPredicate predicateWithFormat:@"propertyName = %@", propertyName];
    NSArray *actions = [self.buildActions filteredArrayUsingPredicate:actionSearch];

    return [[actions lastObject] valueForKey:@"action"];
}

- (BOOL) hasActionForPropertyName:(NSString *)propertyName;
{
    return [self actionForPropertyName:propertyName] != nil;
}

- (id) performActionNamed:(NSString *)propertyName
{
    MRFactoryObjectBuildAction action = [self actionForPropertyName:propertyName];
    
    return action != NULL ? action(self) : nil;
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL)aSelector;
{
    if ([self hasActionForPropertyName:NSStringFromSelector(aSelector)])
    {
        return [super methodSignatureForSelector:@selector(performActionNamed:)];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void) forwardInvocation:(NSInvocation *)anInvocation;
{
    //TODO: need to check for cached value
    
    SEL propertyAsSelector = anInvocation.selector;
    NSString *propertyName = NSStringFromSelector(propertyAsSelector);

    [anInvocation setSelector:@selector(performActionNamed:)];
    [anInvocation setArgument:&propertyName atIndex:2];
    [anInvocation invokeWithTarget:self];
}

- (id) create;
{
    return self;
}

- (id) generate;
{
    self.generateOnNextAccess = YES;
    return self;
}

@end
