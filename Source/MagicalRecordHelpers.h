//
//  MagicalRecordHelpers.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#if TARGET_OS_IPHONE == 0
#define MAC_PLATFORM_ONLY YES
#endif



#ifdef NS_BLOCKS_AVAILABLE

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

@interface MagicalRecordHelpers : NSObject {}

+ (void) cleanUp;

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;
+ (void) setErrorHandlerTarget:(id)target action:(SEL)action;

+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

#ifdef NS_BLOCKS_AVAILABLE
#pragma mark DEPRECATED_METHOD

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;
+ (void) performLookupOperationWithBlock:(CoreDataBlock)block;
+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback;

#endif

@end



//Helper Functions
NSDate * dateFromString(NSString *value);
NSString * attributeNameFromString(NSString *value);

#ifdef MAC_PLATFORM_ONLY

NSColor * NSColorFromString(NSString *serializedColor);

#else

UIColor * UIColorFromString(NSString *serializedColor);

#endif
id (*ColorFromString)(NSString *);

