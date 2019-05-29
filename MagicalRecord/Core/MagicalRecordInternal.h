//
//  MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>

/**
 Defines current and historical version numbers for MagicalRecord.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM(NSUInteger, MagicalRecordVersionTag)
{
    /** Version 2.2.0 */
    MagicalRecordVersionTag2_2 = 220,

    /** Version 2.3.0 */
    MagicalRecordVersionTag2_3 = 230,

    /** Version 3.0.0 */
    MagicalRecordVersionTag3_0 = 300
};

// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#ifdef NS_BLOCKS_AVAILABLE

OBJC_EXPORT NSString * __MR_nonnull const kMagicalRecordCleanedUpNotification;

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext * __MR_nonnull context);

#endif

/**
 Provides class methods to help setup, save, handle errors and provide information about the currently loaded version of MagicalRecord.

 @since Available in v1.0 and later.
 */
NS_ROOT_CLASS @interface MagicalRecord

/**
 Returns the current version of MagicalRecord. See the MagicalRecordVersionTag enumeration for valid current and historical values.

 @return The current version as a double.

 @since Available in v2.3 and later.
 */
+ (MagicalRecordVersionTag) version;

/**
 Provides information about the current stack, including the model, coordinator, persistent store, the default context and any parent contexts of the default context.

 @return Description of the current state of the stack.

 @since Available in v2.3 and later.
 */
+ (MR_nonnull NSString *) currentStack;

/**
 Cleans up the entire MagicalRecord stack. Sets the default model, store and context to nil before posting a kMagicalRecordCleanedUpNotification notification.

 @since Available in v1.0 and later.
 */
+ (void) cleanUp;

/**
 Calls NSBundle's -bundleForClass: to determine the bundle to search for the default model within.

 @param modelClass Class to set the model from

 @since Available in v2.0 and later.
 */
+ (void) setDefaultModelFromClass:(MR_nonnull Class)modelClass;

/**
 Looks for a momd file with the specified name, and if found sets it as the default model.

 @param modelName Model name as a string, including file extension

 @since Available in v1.0 and later.
 */
+ (void) setDefaultModelNamed:(MR_nonnull NSString *)modelName;

/**
 Determines the store file name your app should use. This method is used by the MagicalRecord SQLite stacks when a store file is not specified. The file name returned is in the form "<ApplicationName>.sqlite". `<ApplicationName>` is taken from the application's info dictionary, which is retrieved from the method [[NSBundle mainBundle] infoDictionary]. If no bundle name is available, "CoreDataStore.sqlite" will be used.

 @return String of the form <ApplicationName>.sqlite

 @since Available in v2.0 and later.
 */
+ (MR_nonnull NSString *) defaultStoreName;

@end
