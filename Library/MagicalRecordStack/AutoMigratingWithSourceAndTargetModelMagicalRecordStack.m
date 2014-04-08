//
//  CustomMigratingMagicalRecordStack.m
//  MagicalRecord
//
//  Created by Saul Mora on 10/11/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "AutoMigratingWithSourceAndTargetModelMagicalRecordStack.h"
#import "MagicalRecordStack+Private.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSError+MagicalRecordErrorHandling.h"
#import "MagicalRecordLogging.h"


@interface AutoMigratingWithSourceAndTargetModelMagicalRecordStack ()

@property (nonatomic, strong) NSManagedObjectModel *sourceModel;

@end


@implementation AutoMigratingWithSourceAndTargetModelMagicalRecordStack

- (instancetype) initWithSourceModel:(NSManagedObjectModel *)sourceModel targetModel:(NSManagedObjectModel *)targetModel storeAtURL:(NSURL *)storeURL;
{
    self = [super initWithStoreAtURL:storeURL model:targetModel];
    if (self)
    {
        _sourceModel = sourceModel;
    }
    return self;
}

- (instancetype) initWithSourceModel:(NSManagedObjectModel *)sourceModel targetModel:(NSManagedObjectModel *)targetModel storeAtPath:(NSString *)path;
{
    self = [super initWithStoreAtPath:path model:targetModel];
    if (self)
    {
        _sourceModel = sourceModel;
    }
    return self;
}

- (instancetype) initWithSourceModel:(NSManagedObjectModel *)sourceModel targetModel:(NSManagedObjectModel *)targetModel storeNamed:(NSString *)storeName;
{
    self = [super initWithStoreNamed:storeName model:targetModel];
    if (self)
    {
        _sourceModel = sourceModel;
    }
    return self;
}

- (NSManagedObjectModel *) targetModel;
{
    return self.model;
}

- (NSPersistentStoreCoordinator *)createCoordinator
{
    return [self createCoordinatorWithOptions:[self defaultStoreOptions]];
}

- (NSPersistentStoreCoordinator *)createCoordinatorWithOptions:(NSDictionary *)options;
{
    NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:self.sourceModel destinationModel:self.targetModel];
    NSError *error = nil;
    NSMappingModel *mappingModel = [NSMappingModel inferredMappingModelForSourceModel:self.sourceModel destinationModel:self.targetModel error:&error];
    if (mappingModel == nil)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
        return nil;
    }
    
    NSString *tempPathExtension = [[self.storeURL pathExtension] stringByAppendingString:@"~"];
    NSURL *targetStoreURL = [[self.storeURL URLByDeletingPathExtension] URLByAppendingPathExtension:tempPathExtension];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    BOOL copySuccess = [fileManager copyItemAtURL:self.storeURL toURL:targetStoreURL error:&error];
    if (!copySuccess)
    {
        [[error MR_coreDataDescription] MR_logToConsole];
        return nil;
    }
    
    BOOL migrationSuccess = [migrationManager migrateStoreFromURL:self.storeURL
                                                    type:NSSQLiteStoreType
                                                 options:nil
                                        withMappingModel:mappingModel
                                        toDestinationURL:targetStoreURL
                                         destinationType:NSSQLiteStoreType
                                      destinationOptions:nil
                                                   error:&error];
    
    NSPersistentStoreCoordinator *coordinator = nil;
    if (migrationSuccess)
    {
        [fileManager removeItemAtURL:self.storeURL error:&error];
        [fileManager moveItemAtURL:targetStoreURL toURL:self.storeURL error:&error];
        
        coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.targetModel];
        [coordinator MR_addSqliteStoreAtURL:self.storeURL withOptions:options];
        MRLogInfo(@"Migrated store at URL [%@]", self.storeURL);
    }
    else
    {
        [fileManager removeItemAtURL:targetStoreURL error:&error];
        MRLogWarn(@"Unable to migrate store at URL [%@]", self.storeURL);
        MRLogWarn(@"Source Model: %@", self.sourceModel);
        MRLogWarn(@"Target Model: %@", self.targetModel);
    }
    return coordinator;
}

@end
