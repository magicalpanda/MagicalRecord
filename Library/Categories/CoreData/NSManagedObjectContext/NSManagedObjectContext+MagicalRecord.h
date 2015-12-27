//
//  NSManagedObjectContext+MagicalRecord.h
//
//  Created by Saul Mora on 11/23/09.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordDeprecated.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MagicalRecordDidMergeChangesFromiCloudNotification;

@interface NSManagedObjectContext (MagicalRecord)

- (void)MR_obtainPermanentIDsForObjects:(NSArray *)objects;

+ (NSManagedObjectContext *)MR_context NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *)MR_mainQueueContext NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *)MR_privateQueueContext NS_RETURNS_RETAINED;
+ (NSManagedObjectContext *)MR_privateQueueContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator NS_RETURNS_RETAINED;

- (NSString *)MR_description;
- (NSString *)MR_parentChain;

@end

@interface NSManagedObjectContext (MagicalRecordDeprecated)

+ (NSManagedObjectContext *)MR_confinementContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "a context with a type of `NSPrivateQueueConcurrencyType` or `NSMainQueueConcurrencyType`");
+ (NSManagedObjectContext *)MR_confinementContextWithParent:(NSManagedObjectContext *)parentContext MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", "a context with a type of `NSPrivateQueueConcurrencyType` or `NSMainQueueConcurrencyType`");

@end

NS_ASSUME_NONNULL_END
