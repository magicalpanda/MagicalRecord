//
//  iCloudMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack+Private.h"
#import "iCloudMagicalRecordStack.h"
#import "NSPersistentStoreCoordinator+MagicaliCloudAdditions.h"

@implementation iCloudMagicalRecordStack

- (instancetype) initWithContainerID:(NSString *)container localStoreName:(NSString *)localStoreName;
{
    NSString *contentNameKey = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleIdentifierKey];
    return [self initWithContainerID:container contentNameKey:contentNameKey localStoreName:localStoreName];
}

- (instancetype) initWithContainerID:(NSString *)container contentNameKey:(NSString *)contentNameKey localStoreName:(NSString *)localStoreName;
{
    return [self initWithContainerID:container
                      contentNameKey:contentNameKey
             cloudStorePathComponent:nil
                      localStoreName:localStoreName];
}

- (instancetype) initWithContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey cloudStorePathComponent:(NSString *)cloudStorePathComponent localStoreName:(NSString *)localStoreName;
{
    self = [super init];
    if (self)
    {
        _containerID = containerID;
        _contentNameKey = contentNameKey;
        _cloudStorePathComponent = cloudStorePathComponent;
        _localStoreName = localStoreName;
    }
    return self;
}

- (NSPersistentStoreCoordinator *) createCoordinator;
{
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
    [coordinator MR_addiCloudContainerID:self.containerID
                          contentNameKey:self.contentNameKey
                         localStoreNamed:self.localStoreName
                 cloudStorePathComponent:self.cloudStorePathComponent
                              completion:self.setupCompletionBlock];
    return coordinator;
}

@end
