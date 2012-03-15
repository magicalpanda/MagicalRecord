//
//  MagicalRecord+iCloud.m
//  Magical Record
//
//  Created by Saul Mora on 3/7/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+iCloud.h"

@implementation MagicalRecord (iCloud)

#pragma mark - iCloud Methods

+ (BOOL) isICloudEnabled;
{
    NSURL *cloudURL = [NSPersistentStore MR_cloudURLForUbiqutiousContainer:nil];
    return cloudURL != nil;
}

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
{
    NSString *contentNameKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    [self setupCoreDataStackWithiCloudContainer:icloudBucket contentNameKey:contentNameKey localStoreNamed:localStore cloudStorePathComponent:nil];
}

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
{
    [self setupCoreDataStackWithiCloudContainer:containerID contentNameKey:contentNameKey localStoreNamed:localStoreName cloudStorePathComponent:pathSubcomponent completion:nil];
}

+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
{
    NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithiCloudContainerID:containerID
                                                                                                   contentNameKey:contentNameKey 
                                                                                                  localStoreNamed:localStoreName 
                                                                                          cloudStorePathComponent:pathSubcomponent
                                                                                                       completion:completion];
    [NSPersistentStoreCoordinator MR_setDefaultStoreCoordinator:coordinator];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithStoreCoordinator:coordinator];
    [NSManagedObjectContext MR_setDefaultContext:context];
}

@end
