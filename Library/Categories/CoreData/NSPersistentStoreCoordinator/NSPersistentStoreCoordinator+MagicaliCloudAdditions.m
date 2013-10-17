//
//  NSPersistentStoreCoordinator+MagicaliCloudAdditions.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "NSPersistentStoreCoordinator+MagicaliCloudAdditions.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "MagicalRecord.h"
#import "MagicalRecordLogging.h"


NSString * const kMagicalRecordPSCDidCompleteiCloudSetupNotification = @"kMagicalRecordPSCDidCompleteiCloudSetupNotification";

@implementation NSPersistentStoreCoordinator (MagicaliCloudAdditions)


+ (NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(NSString *)containerID
                                                        contentNameKey:(NSString *)contentNameKey
                                                       localStoreNamed:(NSString *)localStoreName
                                               cloudStorePathComponent:(NSString *)subPathComponent;
{
    return [self MR_coordinatorWithiCloudContainerID:containerID
                                      contentNameKey:contentNameKey
                                     localStoreNamed:localStoreName
                             cloudStorePathComponent:subPathComponent
                                          completion:nil];
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithiCloudContainerID:(NSString *)containerID
                                                        contentNameKey:(NSString *)contentNameKey
                                                       localStoreNamed:(NSString *)localStoreName
                                               cloudStorePathComponent:(NSString *)subPathComponent
                                                            completion:(void(^)(void))completionHandler;
{
    NSManagedObjectModel *model = [[MagicalRecordStack defaultStack] model];
    NSPersistentStoreCoordinator *psc = [[self alloc] initWithManagedObjectModel:model];

    [psc MR_addiCloudContainerID:containerID
                  contentNameKey:contentNameKey
                 localStoreNamed:localStoreName
         cloudStorePathComponent:subPathComponent
                      completion:completionHandler];

    return psc;
}

- (void) MR_addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent;
{
    [self MR_addiCloudContainerID:containerID
                   contentNameKey:contentNameKey
                  localStoreNamed:localStoreName
          cloudStorePathComponent:subPathComponent
                       completion:nil];
}

- (void) MR_addiCloudContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)subPathComponent completion:(void(^)(void))completionBlock;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *cloudURL = [NSPersistentStore MR_cloudURLForUbiqutiousContainer:containerID];
        if (subPathComponent)
        {
            cloudURL = [cloudURL URLByAppendingPathComponent:subPathComponent];
        }

        NSDictionary *options = [NSDictionary MR_autoMigrationOptions];
        if (cloudURL)   //iCloud is available
        {
            NSDictionary *iCloudOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                           contentNameKey, NSPersistentStoreUbiquitousContentNameKey,
                                           cloudURL, NSPersistentStoreUbiquitousContentURLKey, nil];
            options = [options MR_dictionaryByMergingDictionary:iCloudOptions];
        }
        else
        {
            MRLogWarn(@"iCloud is not enabled");
        }

        [self lock];
        [self MR_addSqliteStoreNamed:localStoreName withOptions:options];
        [self unlock];

        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[MagicalRecordStack defaultStack] store] == nil)
            {
                [[MagicalRecordStack defaultStack]setStore:[[self persistentStores] objectAtIndex:0]];
            }
            if (completionBlock)
            {
                completionBlock();
            }
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            [notificationCenter postNotificationName:kMagicalRecordPSCDidCompleteiCloudSetupNotification object:nil];
        });
    });   
}

@end
