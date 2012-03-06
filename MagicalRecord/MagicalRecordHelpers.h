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

@interface MagicalRecordHelpers : NSObject

+ (NSString *) currentStack;

+ (void) cleanUp;

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action;
+ (SEL) errorHandlerAction;
+ (id) errorHandlerTarget;

+ (void) setDefaultModelForTestCase:(Class)aClass;
+ (void) setDefaultModelNamed:(NSString *)modelName;
+ (NSString *) defaultStoreName;

//global options
// enable/disable logging
// add logging provider
// autocreate new PSC per Store
// autoassign new instances to default store
+ (BOOL) shouldAutoCreateManagedObjectModel;
+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)shouldAutoCreate;
+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;
+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)shouldAutoCreate;


+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

#pragma mark - iCloud Support

+ (BOOL) isICloudEnabled;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;

#ifdef NS_BLOCKS_AVAILABLE
#pragma mark DEPRECATED_METHOD

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;
+ (void) performLookupOperationWithBlock:(CoreDataBlock)block;
+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block completion:(void(^)(void))callback;

#endif

@end


//Helper Functions
NSDate * adjustDateForDST(NSDate *date);
NSDate * dateFromString(NSString *value, NSString *format);
NSString * attributeNameFromString(NSString *value);
NSString * primaryKeyNameFromString(NSString *value);

#if TARGET_OS_IPHONE

UIColor * UIColorFromString(NSString *serializedColor);

#else

NSColor * NSColorFromString(NSString *serializedColor);

#endif
extern id (*colorFromString)(NSString *);

