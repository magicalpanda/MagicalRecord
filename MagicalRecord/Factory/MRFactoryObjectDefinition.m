//
//  MRFactoryObject.m
//  MagicalRecord
//
//  Created by Saul Mora on 6/18/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MRFactoryObjectDefinition.h"
#import <objc/runtime.h>


@interface MRFactoryObjectDefinition ()

@property (nonatomic, copy, readwrite) NSString *alias;
@property (nonatomic, assign, readwrite) Class factoryClass;
@property (nonatomic, strong, readwrite) NSMutableArray *buildActions;
@property (nonatomic, assign, readwrite) BOOL generateOnNextAccess;
@property (nonatomic, strong, readwrite) NSSet *associatedFactories;

@property (nonatomic, strong, readwrite) id cachedValue;

@end


@implementation MRFactoryObjectDefinition

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

+ (id) factoryWithClass:(Class)klass;
{
    return [[self alloc] initWithClass:klass];
}

+ (id) factoryWithClass:(Class)klass as:(NSString *)alias;
{
    return nil;
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
    self.cachedValue = sequence;
    return self;
}

- (id) forProperty;
{
    //time to set cached value
    return self;
}

- (void) setValue:(id)value forPropertyNamed:(NSString *)propertyName;
{
    __weak id weakValue = value;
    MRFactoryObjectBuildAction action = ^id(MRFactoryObjectDefinition *obj)
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
    MRFactoryObjectBuildAction sequenceActionWrapper = ^id(MRFactoryObjectDefinition *obj){
        
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

//
//- (id) createInstance;
//{
//    MRFactoryObject *object = [MRFactoryObject new];
//    
//    for (id actionPair in self.buildActions)
//    {
//        NSString *propertyName = [[actionPair allKeys] lastObject];
//        MRFactoryObjectBuildAction action = [actionPair valueForKey:propertyName];
//        
//        int (^propertyAction)(id) = ^int(id _self)
//        {
//            action(_self);
//            return 0;
//        };
//        
//        IMP implementation = imp_implementationWithBlock((__bridge void *)(propertyAction));
//        class_addMethod([self class], NSSelectorFromString(propertyName), implementation, @encode(id));
//    }
//    
//    return object;
//}

@end
