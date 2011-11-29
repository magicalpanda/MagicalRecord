//
//  MagicalRecordHelpers.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

static NSString * const kMagicalRecordCategoryPrefix = @"MR_";
#ifdef MR_SHORTHAND
static BOOL methodsHaveBeenSwizzled = NO;
#endif

static id errorHandlerTarget = nil;
static SEL errorHandlerAction = nil;

static BOOL shouldAutoCreateManagedObjectModel_;
static BOOL shouldAutoCreateDefaultPersistentStoreCoordinator_;

//Dynamic shorthand method helpers
BOOL addMagicalRecordShortHandMethodToPrefixedClassMethod(Class class, SEL selector);
BOOL addMagicalRecordShorthandMethodToPrefixedInstanceMethod(Class klass, SEL originalSelector);

void swizzleInstanceMethods(Class originalClass, SEL originalSelector, Class targetClass, SEL newSelector);
void replaceSelectorForTargetWithSourceImpAndSwizzle(Class originalClass, SEL originalSelector, Class newClass, SEL newSelector);

@implementation MagicalRecordHelpers

+ (void) cleanUp
{
    errorHandlerTarget = nil;
    errorHandlerAction = nil;
	[MRCoreDataAction cleanUp];
	[NSManagedObjectContext MR_setDefaultContext:nil];
	[NSManagedObjectModel MR_setDefaultManagedObjectModel:nil];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:nil];
	[NSPersistentStore MR_setDefaultPersistentStore:nil];
}

+ (NSString *) currentStack
{
    NSMutableString *status = [NSMutableString stringWithString:@"Current Default Core Data Stack: ---- \n"];
    
    [status appendFormat:@"Context:     %@\n", [NSManagedObjectContext MR_defaultContext]];
    [status appendFormat:@"Model:       %@\n", [NSManagedObjectModel MR_defaultManagedObjectModel]];
    [status appendFormat:@"Coordinator: %@\n", [NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
    [status appendFormat:@"Store:       %@\n", [NSPersistentStore MR_defaultPersistentStore]];
    
    return status;
}

+ (void) defaultErrorHandler:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    for (NSArray *detailedError in [userInfo allValues])
    {
        if ([detailedError isKindOfClass:[NSArray class]])
        {
            for (NSError *e in detailedError)
            {
                if ([e respondsToSelector:@selector(userInfo)])
                {
                    MRLog(@"Error Details: %@", [e userInfo]);
                }
                else
                {
                    MRLog(@"Error Details: %@", e);
                }
            }
        }
        else
        {
            MRLog(@"Error: %@", detailedError);
        }
    }
    MRLog(@"Error Domain: %@", [error domain]);
    MRLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);
}

+ (void) handleErrors:(NSError *)error
{
	if (error)
	{
        // If a custom error handler is set, call that
        if (errorHandlerTarget != nil && errorHandlerAction != nil) 
		{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [errorHandlerTarget performSelector:errorHandlerAction withObject:error];
#pragma clang diagnostic pop
        }
		else
		{
	        // Otherwise, fall back to the default error handling
	        [self defaultErrorHandler:error];			
		}
    }
}

+ (id) errorHandlerTarget
{
    return errorHandlerTarget;
}

+ (SEL) errorHandlerAction
{
    return errorHandlerAction;
}

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action
{
    errorHandlerTarget = target;    /* Deliberately don't retain to avoid potential retain cycles */
    errorHandlerAction = action;
}

- (void) handleErrors:(NSError *)error
{
	[[self class] handleErrors:error];
}

+ (void) setDefaultModelNamed:(NSString *)modelName;
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_managedObjectModelNamed:modelName];
    [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
}

+ (NSString *) defaultStoreName;
{
    NSString *defaultName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(id)kCFBundleNameKey];
    if (defaultName == nil)
    {
        defaultName = kMagicalRecordDefaultStoreFileName;
    }
    if (![defaultName hasSuffix:@"sqlite"]) 
    {
        defaultName = [defaultName stringByAppendingPathExtension:@"sqlite"];
    }

    return defaultName;
}

+ (void) setupCoreDataStack
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_context];
	[NSManagedObjectContext MR_setDefaultContext:context];
}

+ (void) setupAutoMigratingCoreDataStack
{
    [self setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self defaultStoreName]];
}

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName
{
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:storeName];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
	NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
	[NSManagedObjectContext MR_setDefaultContext:context];
}

+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setDefaultContext:context];
}

+ (void) setupCoreDataStackWithInMemoryStore;
{
	NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
	[NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
	
	NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
	[NSManagedObjectContext MR_setDefaultContext:context];
}

#pragma mark - iCloud Methods

+ (BOOL) isICloudEnabled;
{
    NSURL *cloudURL = [NSPersistentStore MR_cloudURLForUbiqutiousContainer:nil];
    return cloudURL != nil;
}

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
{
    [self setupCoreDataStackWithiCloudContainer:icloudBucket contentNameKey:nil localStoreNamed:localStore cloudStorePathComponent:nil];
}

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithiCloudContainerID:containerID
                                                                                                   contentNameKey:contentNameKey 
                                                                                                  localStoreNamed:localStoreName 
                                                                                          cloudStorePathComponent:pathSubcomponent];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setDefaultContext:context];
    
    [context MR_observeiCloudChangesInCoordinator:coordinator];    
}

#pragma mark - Options

+ (BOOL) shouldAutoCreateManagedObjectModel;
{
    return shouldAutoCreateManagedObjectModel_;
}

+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)shouldAutoCreate;
{
    shouldAutoCreateManagedObjectModel_ = shouldAutoCreate;
}

+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;
{
    return shouldAutoCreateDefaultPersistentStoreCoordinator_;
}

+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)shouldAutoCreate;
{
    shouldAutoCreateDefaultPersistentStoreCoordinator_ = shouldAutoCreate;
}


#ifdef NS_BLOCKS_AVAILABLE
#pragma mark DEPRECATED_METHOD

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
{
    [MRCoreDataAction saveDataWithBlock:block];
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;
{
    [MRCoreDataAction saveDataInBackgroundWithBlock:block];
}

+ (void) performLookupOperationWithBlock:(CoreDataBlock)block;
{
    [MRCoreDataAction lookupWithBlock:block];
}

+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback;
{
    [MRCoreDataAction saveDataInBackgroundWithBlock:block completion:callback];
}

#endif

#pragma mark - Support methods for shorthand methods

#ifdef MR_SHORTHAND
+ (BOOL) MR_resolveClassMethod:(SEL)originalSelector
{
    BOOL resolvedClassMethod = [self MR_resolveClassMethod:originalSelector];
    if (!resolvedClassMethod) 
    {
        resolvedClassMethod = addMagicalRecordShortHandMethodToPrefixedClassMethod(self, originalSelector);
    }
    return resolvedClassMethod;
}

+ (BOOL) MR_resolveInstanceMethod:(SEL)originalSelector
{
    BOOL resolvedClassMethod = [self MR_resolveInstanceMethod:originalSelector];
    if (!resolvedClassMethod) 
    {
        resolvedClassMethod = addMagicalRecordShorthandMethodToPrefixedInstanceMethod(self, originalSelector);
    }
    return resolvedClassMethod;
}

//In order to add support for non-prefixed AND prefixed methods, we need to swap the existing resolveClassMethod: and resolveInstanceMethod: implementations with the one in this class.
+ (void) updateResolveMethodsForClass:(Class)klass
{
    replaceSelectorForTargetWithSourceImpAndSwizzle(self, @selector(MR_resolveClassMethod:), klass, @selector(resolveClassMethod:));
    replaceSelectorForTargetWithSourceImpAndSwizzle(self, @selector(MR_resolveInstanceMethod:), klass, @selector(resolveInstanceMethod:));    
}

+ (void) swizzleShorthandMethods;
{
    if (methodsHaveBeenSwizzled) return;
    
    NSArray *classes = [NSArray arrayWithObjects:
                        [NSManagedObject class],
                        [NSManagedObjectContext class], 
                        [NSManagedObjectModel class], 
                        [NSPersistentStore class], 
                        [NSPersistentStoreCoordinator class], nil];
    
    [classes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Class klass = (Class)obj;
        
        [self updateResolveMethodsForClass:klass];
    }];
    methodsHaveBeenSwizzled = YES;
}
#endif

#pragma mark - initialize

+ (void) initialize;
{
    if (self == [MagicalRecordHelpers class]) 
    {
#ifdef MR_SHORTHAND
        [self swizzleShorthandMethods];
#endif
        [self setShouldAutoCreateManagedObjectModel:YES];
        [self setShouldAutoCreateDefaultPersistentStoreCoordinator:YES];
    }
}

@end

#pragma mark - Support functions for runtime shorthand Method calling

void replaceSelectorForTargetWithSourceImpAndSwizzle(Class sourceClass, SEL sourceSelector, Class targetClass, SEL targetSelector)
{
    Method sourceClassMethod = class_getClassMethod(sourceClass, sourceSelector);
    Method targetClassMethod = class_getClassMethod(targetClass, targetSelector);

    Class targetMetaClass = objc_getMetaClass([NSStringFromClass(targetClass) cStringUsingEncoding:NSUTF8StringEncoding]);
    
    BOOL methodWasAdded = class_addMethod(targetMetaClass, sourceSelector,
                                          method_getImplementation(targetClassMethod),
                                          method_getTypeEncoding(targetClassMethod));
    
    if (methodWasAdded)
    {
        class_replaceMethod(targetMetaClass, targetSelector, 
                            method_getImplementation(sourceClassMethod), 
                            method_getTypeEncoding(sourceClassMethod));
    }
}

BOOL addMagicalRecordShorthandMethodToPrefixedInstanceMethod(Class klass, SEL originalSelector)
{
    NSString *originalSelectorString = NSStringFromSelector(originalSelector);
    if ([originalSelectorString hasPrefix:@"_"] || [originalSelectorString hasPrefix:@"init"]) return NO;
    
    if (![originalSelectorString hasPrefix:kMagicalRecordCategoryPrefix]) 
    {
        NSString *prefixedSelector = [kMagicalRecordCategoryPrefix stringByAppendingString:originalSelectorString];
        Method existingMethod = class_getInstanceMethod(klass, NSSelectorFromString(prefixedSelector));
        
        if (existingMethod) 
        {
            BOOL methodWasAdded = class_addMethod(klass, 
                                                  originalSelector, 
                                                  method_getImplementation(existingMethod), 
                                                  method_getTypeEncoding(existingMethod));
            
            return methodWasAdded;
        }
    }
    return NO;
}
                                    

BOOL addMagicalRecordShortHandMethodToPrefixedClassMethod(Class klass, SEL originalSelector)
{
    NSString *originalSelectorString = NSStringFromSelector(originalSelector);
    if (![originalSelectorString hasPrefix:kMagicalRecordCategoryPrefix]) 
    {
        NSString *prefixedSelector = [kMagicalRecordCategoryPrefix stringByAppendingString:originalSelectorString];
        Method existingMethod = class_getClassMethod(klass, NSSelectorFromString(prefixedSelector));
        
        if (existingMethod) 
        {
            Class metaClass = objc_getMetaClass([NSStringFromClass(klass) cStringUsingEncoding:NSUTF8StringEncoding]);
            BOOL methodWasAdded = class_addMethod(metaClass, 
                                                  originalSelector, 
                                                  method_getImplementation(existingMethod), 
                                                  method_getTypeEncoding(existingMethod));
            
            return methodWasAdded;
        }
    }
    return NO;
}

#pragma mark - Data import helper functions

NSString * attributeNameFromString(NSString *value)
{
    NSString *firstCharacter = [[value substringToIndex:1] capitalizedString];
    return [firstCharacter stringByAppendingString:[value substringFromIndex:1]];
}

NSString * primaryKeyNameFromString(NSString *value)
{
    NSString *firstCharacter = [[value substringToIndex:1] lowercaseString];
    return [firstCharacter stringByAppendingFormat:@"%@ID", [value substringFromIndex:1]];
}

NSDate * adjustDateForDST(NSDate *date)
{
    NSTimeInterval dstOffset = [[NSTimeZone localTimeZone] daylightSavingTimeOffsetForDate:date];
    NSDate *actualDate = [date dateByAddingTimeInterval:dstOffset];

    return actualDate;
}

NSDate * dateFromString(NSString *value, NSString *format)
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    
    NSDate *parsedDate = [formatter dateFromString:value];
#ifndef NS_AUTOMATED_REFCOUNT_UNAVAILABLE
    [formatter autorelease];
#endif
    
    return parsedDate;
}

NSInteger* newColorComponentsFromString(NSString *serializedColor);
NSInteger* newColorComponentsFromString(NSString *serializedColor)
{
    NSScanner *colorScanner = [NSScanner scannerWithString:serializedColor];
    NSString *colorType;
    [colorScanner scanUpToString:@"(" intoString:&colorType];
    
    NSInteger *componentValues = malloc(4 * sizeof(NSInteger));
    if ([colorType hasPrefix:@"rgba"])
    {
        NSCharacterSet *rgbaCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"(,)"];

        NSInteger *componentValue = componentValues;
        while (![colorScanner isAtEnd]) 
        {
            [colorScanner scanCharactersFromSet:rgbaCharacterSet intoString:nil];
            [colorScanner scanInteger:componentValue];
            componentValue++;
        }
    }
    //else if ([colorType hasPrefix:@"hsba"])
    //else if ([colorType hasPrefix:@""])
    return componentValues;
}

#if TARGET_OS_IPHONE

UIColor * UIColorFromString(NSString *serializedColor)
{
    NSInteger *componentValues = newColorComponentsFromString(serializedColor);
    UIColor *color = [UIColor colorWithRed:(componentValues[0] / 255.)
                                     green:(componentValues[1] / 255.)
                                      blue:(componentValues[2] / 255.)
                                     alpha:componentValues[3]];
    
    free(componentValues);
    return color;
}
id (*colorFromString)(NSString *) = UIColorFromString;

#else

NSColor * NSColorFromString(NSString *serializedColor)
{
    NSInteger *componentValues = newColorComponentsFromString(serializedColor);
    NSColor *color = [NSColor colorWithDeviceRed:(componentValues[0] / 255.)
                                      green:(componentValues[1] / 255.)
                                       blue:(componentValues[2] / 255.)
                                      alpha:componentValues[3]];
    free(componentValues);
    return color;
}
id (*colorFromString)(NSString *) = NSColorFromString;


#endif
