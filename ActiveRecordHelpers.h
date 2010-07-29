//
//  ActiveRecordHelpers.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NS_BLOCKS_AVAILABLE

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *);

#endif

@interface ActiveRecordHelpers : NSObject {

}

+ (void) cleanUp;

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;

+ (void) setupCoreDataStack;
+ (void) setupCoreDataStackWithInMemoryStore;
+ (void) setupAutoMigratingCoreDataStack;

+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

#ifdef NS_BLOCKS_AVAILABLE

+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;

#endif

@end
