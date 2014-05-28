//
//  MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

/**
 Defines current and historical version numbers for MagicalRecord.

 @since Available in v2.3 and later.
 */
typedef NS_ENUM(NSUInteger, MagicalRecordVersionNumber)
{
    /** Version 2.2.0 */
    MagicalRecordVersionNumber2_2 = 220,

    /** Version 2.3.0 */
    MagicalRecordVersionNumber2_3 = 230,

    /** Version 3.0.0 */
    MagicalRecordVersionNumber3_0 = 300
};

// enable to use caches for the fetchedResultsControllers (iOS only)
// #define STORE_USE_CACHE

#ifdef NS_BLOCKS_AVAILABLE

extern NSString * const kMagicalRecordCleanedUpNotification;

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

/**
 Provides class methods to help setup, save, handle errors and provide information about the currently loaded version of MagicalRecord.

 @since Available in v1.0 and later
 */
@interface MagicalRecord : NSObject

/**
 Returns the current version of MagicalRecord. See the MagicalRecordVersionNumber enumeration for valid current and historical values.

 @return The current version as a double.

 @since Available in v2.3 and later
 */
+ (MagicalRecordVersionNumber) version;

/**
 Provides information about the current stack, including the model, coordinator, persistent store, the default context and any parent contexts of the default context.

 @return Description of the current state of the stack.

 @since Available in v2.3 and later
 */
+ (NSString *) currentStack;

+ (void) cleanUp;

+ (void) setDefaultModelFromClass:(Class)klass;
+ (void) setDefaultModelNamed:(NSString *)modelName;
+ (NSString *) defaultStoreName;

@end
