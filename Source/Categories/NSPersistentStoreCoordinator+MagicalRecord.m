//
//  NSPersistentStoreCoordinator+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "CoreData+MagicalRecord.h"

static NSPersistentStoreCoordinator *defaultCoordinator_ = nil;
NSString * const kMagicalRecordPSCDidCompleteiCloudSetupNotification = @"kMagicalRecordPSCDidCompleteiCloudSetupNotification";

@interface NSDictionary (Merging) 

- (NSMutableDictionary*) MR_dictionaryByMergingDictionary:(NSDictionary*)d; 

@end 

@implementation NSPersistentStoreCoordinator (MagicalRecord)

+ (NSPersistentStoreCoordinator *) MR_defaultStoreCoordinator
{
    if (defaultCoordinator_ == nil && [MagicalRecordHelpers shouldAutoCreateDefaultPersistentStoreCoordinator])
    {
        [self MR_setDefaultStoreCoordinator:[self MR_newPersistentStoreCoordinator]];
    }
	return defaultCoordinator_;
}

+ (void) MR_setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    MR_RETAIN(coordinator);
    MR_RELEASE(defaultCoordinator_);
	defaultCoordinator_ = coordinator;
    
    if (defaultCoordinator_ != nil)
    {
        NSArray *persistentStores = [defaultCoordinator_ persistentStores];
        
        if ([persistentStores count] && [NSPersistentStore MR_defaultPersistentStore] == nil)
        {
            [NSPersistentStore MR_setDefaultPersistentStore:[persistentStores objectAtIndex:0]];
        }
    }
}

- (void) MR_createPathToStoreFileIfNeccessary:(NSURL *)urlForStore
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *pathToStore = [urlForStore URLByDeletingLastPathComponent];
    
    NSError *error = nil;
    BOOL pathWasCreated = [fileManager createDirectoryAtPath:[pathToStore path] withIntermediateDirectories:YES attributes:nil error:&error];

    if (!pathWasCreated) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
}

- (NSPersistentStore *) MR_addSqliteStoreNamed:(id)storeFileName withOptions:(__autoreleasing NSDictionary *)options
{
    NSURL *url = [storeFileName isKindOfClass:[NSURL class]] ? storeFileName : [NSPersistentStore MR_urlForStoreName:storeFileName];
    NSError *error = nil;
    
    [self MR_createPathToStoreFileIfNeccessary:url];
    
    NSPersistentStore *store = [self addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil
                                                           URL:url
                                                       options:options
                                                         error:&error];
    if (!store) 
    {
        [MagicalRecordHelpers handleErrors:error];
    }
    return store;
}


#pragma mark - Public Instance Methods

- (NSPersistentStore *) MR_addInMemoryStore
{
    NSError *error = nil;
    NSPersistentStore *store = [self addPersistentStoreWithType:NSInMemoryStoreType
                                                  configuration:nil 
                                                            URL:nil
                                                        options:nil
                                                          error:&error];
    if (!store)
    {
        [MagicalRecordHelpers handleErrors:error];
    }
    return store;
}

+ (NSDictionary *) MR_autoMigrationOptions;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             nil];
    return options;
}

- (NSPersistentStore *) MR_addAutoMigratingSqliteStoreNamed:(NSString *) storeFileName;
{
    NSDictionary *options = [[self class] MR_autoMigrationOptions];
    return [self MR_addSqliteStoreNamed:storeFileName withOptions:options];
}


#pragma mark - Public Class Methods


+ (NSPersistentStoreCoordinator *) MR_coordinatorWithAutoMigratingSqliteStoreNamed:(NSString *) storeFileName
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [coordinator MR_addAutoMigratingSqliteStoreNamed:storeFileName];
    
    //HACK: lame solution to fix automigration error "Migration failed after first pass"
    if ([[coordinator persistentStores] count] == 0) 
    {
        [coordinator performSelector:@selector(MR_addAutoMigratingSqliteStoreNamed:) withObject:storeFileName afterDelay:0.5];
    }
    MR_AUTORELEASE(coordinator);
    return coordinator;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithInMemoryStore
{
	NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
	NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    [coordinator MR_addInMemoryStore];
    MR_AUTORELEASE(coordinator);

    return coordinator;
}

+ (NSPersistentStoreCoordinator *) MR_newPersistentStoreCoordinator
{
	NSPersistentStoreCoordinator *coordinator = [self MR_coordinatorWithSqliteStoreNamed:[MagicalRecordHelpers defaultStoreName]];
    MR_RETAIN(coordinator);
    return coordinator;
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

        NSDictionary *options = [[self class] MR_autoMigrationOptions];
        if (cloudURL)   //iCloud is available
        {
            NSDictionary *iCloudOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                           contentNameKey, NSPersistentStoreUbiquitousContentNameKey,
                                           cloudURL, NSPersistentStoreUbiquitousContentURLKey, nil];
            options = [options MR_dictionaryByMergingDictionary:iCloudOptions];
        }
        else 
        {
            MRLog(@"iCloud is not enabled");
        }
        
        [self lock];
        [self MR_addSqliteStoreNamed:localStoreName withOptions:options];
        [self unlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([NSPersistentStore MR_defaultPersistentStore] == nil)
            {
                [NSPersistentStore MR_setDefaultPersistentStore:[[self persistentStores] objectAtIndex:0]];
            }
            if (completionBlock)
            {
                completionBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kMagicalRecordPSCDidCompleteiCloudSetupNotification object:nil]; 
        });
    });   
}

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
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc MR_addiCloudContainerID:containerID 
                  contentNameKey:contentNameKey
                 localStoreNamed:localStoreName
         cloudStorePathComponent:subPathComponent
                      completion:completionHandler];
    
    MR_AUTORELEASE(psc);
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithPersitentStore:(NSPersistentStore *)persistentStore;
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc MR_addSqliteStoreNamed:[persistentStore URL] withOptions:nil];
    MR_AUTORELEASE(psc);
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName withOptions:(NSDictionary *)options
{
    NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    [psc MR_addSqliteStoreNamed:storeFileName withOptions:options];
    MR_AUTORELEASE(psc);
    return psc;
}

+ (NSPersistentStoreCoordinator *) MR_coordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
	return [self MR_coordinatorWithSqliteStoreNamed:storeFileName withOptions:nil];
}

@end


@implementation NSDictionary (Merging) 

- (NSMutableDictionary *) MR_dictionaryByMergingDictionary:(NSDictionary *)d;
{
    NSMutableDictionary *mutDict = [self mutableCopy];
    [mutDict addEntriesFromDictionary:d];
    MR_AUTORELEASE(mutDict);
    return mutDict; 
} 

@end 