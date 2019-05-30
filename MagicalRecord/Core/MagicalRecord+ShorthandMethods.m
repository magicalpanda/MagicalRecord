//
//  Copyright (c) 2015 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecord+ShorthandMethods.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>

static NSString *const kMagicalRecordCategoryPrefix = @"MR_";
static BOOL kMagicalRecordShorthandMethodsSwizzled = NO;

@implementation MagicalRecord (ShorthandMethods)

+ (void)enableShorthandMethods
{
    if (kMagicalRecordShorthandMethodsSwizzled == NO)
    {
        NSArray *classes = [self classesToSwizzle];

        [classes enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            Class objectClass = (Class)object;

            [self updateResolveMethodsForClass:objectClass];
        }];

        kMagicalRecordShorthandMethodsSwizzled = YES;
    }
}

+ (NSArray *)classesToSwizzle
{
    return @[ [NSManagedObject class],
              [NSManagedObjectContext class],
              [NSManagedObjectModel class],
              [NSPersistentStore class],
              [NSPersistentStoreCoordinator class] ];
}

+ (NSArray *)methodNameBlacklist
{
    return @[ NSStringFromSelector(@selector(entityName)) ];
}

+ (BOOL)MR_resolveClassMethod:(SEL)originalSelector
{
    BOOL resolvedClassMethod = [self MR_resolveClassMethod:originalSelector];
    if (!resolvedClassMethod)
    {
        resolvedClassMethod = MRAddShortHandMethodForPrefixedClassMethod(self, originalSelector, kMagicalRecordCategoryPrefix);
    }
    return resolvedClassMethod;
}

+ (BOOL)MR_resolveInstanceMethod:(SEL)originalSelector
{
    BOOL resolvedClassMethod = [self MR_resolveInstanceMethod:originalSelector];
    if (!resolvedClassMethod)
    {
        resolvedClassMethod = MRAddShorthandMethodForPrefixedInstanceMethod(self, originalSelector, kMagicalRecordCategoryPrefix);
    }
    return resolvedClassMethod;
}

// In order to add support for non-prefixed AND prefixed methods, we need to swap the existing resolveClassMethod: and resolveInstanceMethod: implementations with the one in this class.
+ (void)updateResolveMethodsForClass:(Class)objectClass
{
    MRReplaceSelectorForTargetWithSourceImplementation(self, @selector(MR_resolveClassMethod:), objectClass, @selector(resolveClassMethod:));
    MRReplaceSelectorForTargetWithSourceImplementation(self, @selector(MR_resolveInstanceMethod:), objectClass, @selector(resolveInstanceMethod:));
}

static void MRReplaceSelectorForTargetWithSourceImplementation(Class sourceClass, SEL sourceSelector, Class targetClass, SEL targetSelector)
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

static BOOL MRAddShorthandMethodForPrefixedInstanceMethod(Class objectClass, SEL originalSelector, NSString *prefix)
{
    NSString *originalSelectorString = NSStringFromSelector(originalSelector);

    if ([originalSelectorString hasPrefix:prefix] == NO)
    {
        NSString *prefixedSelector = [prefix stringByAppendingString:originalSelectorString];
        Method existingMethod = class_getInstanceMethod(objectClass, NSSelectorFromString(prefixedSelector));

        if (existingMethod)
        {
            BOOL methodWasAdded = class_addMethod(objectClass,
                                                  originalSelector,
                                                  method_getImplementation(existingMethod),
                                                  method_getTypeEncoding(existingMethod));

            return methodWasAdded;
        }
    }
    return NO;
}

static BOOL MRAddShortHandMethodForPrefixedClassMethod(Class objectClass, SEL originalSelector, NSString *prefix)
{
    NSString *originalSelectorString = NSStringFromSelector(originalSelector);

    if ([originalSelectorString hasPrefix:prefix] == NO &&
        [originalSelectorString hasSuffix:@"entityName"] == NO)
    {
        NSString *prefixedSelector = [prefix stringByAppendingString:originalSelectorString];
        Method existingMethod = class_getClassMethod(objectClass, NSSelectorFromString(prefixedSelector));

        if (existingMethod)
        {
            Class metaClass = objc_getMetaClass([NSStringFromClass(objectClass) cStringUsingEncoding:NSUTF8StringEncoding]);
            BOOL methodWasAdded = class_addMethod(metaClass,
                                                  originalSelector,
                                                  method_getImplementation(existingMethod),
                                                  method_getTypeEncoding(existingMethod));

            return methodWasAdded;
        }
    }
    return NO;
}

@end
