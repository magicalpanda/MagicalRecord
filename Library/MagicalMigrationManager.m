//
//  MagicalMigrationManager.m
//  Photobucket Next
//
//  Created by Saul Mora on 8/6/13.
//  Copyright (c) 2013 Photobucket. All rights reserved.
//

#import "MagicalMigrationManager.h"

@implementation MagicalMigrationManager

- (instancetype) initWithSourceModelName:(NSString *)sourceName targetModelName:(NSString *)targetName;
{
    self = [super init];
    if (self)
    {
        _sourceModelName = sourceName;
        _targetModelName = targetName;
    }
    return self;
}

- (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelName;
{
    NSString *bundleModelName = modelName;
    if (self.versionedModelName)
    {
        bundleModelName = [[self.versionedModelName stringByAppendingPathExtension:@"momd"] stringByAppendingPathComponent:modelName];
    }

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:bundleModelName withExtension:@"mom"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return model;
}

- (NSManagedObjectModel *) sourceModel;
{
    return [self managedObjectModelNamed:self.sourceModelName];
}

- (NSManagedObjectModel *) targetModel;
{
    return [self managedObjectModelNamed:self.targetModelName];
}

- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL
{
    return [self migrateStoreAtURL:sourceStoreURL toStoreAtURL:targetStoreURL mappingModelURL:nil];
}

- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL mappingModelURL:(NSURL *)mappingModelURL;
{
    return [self migrateStoreAtURL:sourceStoreURL toStoreAtURL:targetStoreURL mappingModelURL:mappingModelURL progressiveMigration:YES];
}

- (BOOL) migrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL mappingModelURL:(NSURL *)mappingModelURL progressiveMigration:(BOOL)progressiveMigration;
{
    NSManagedObjectModel *sourceModel = [self sourceModel];
    NSManagedObjectModel *targetModel = [self targetModel];

    NSMappingModel *mappingModel = [self mappingModelAtURL:mappingModelURL
                                            forSourceModel:sourceModel
                                               targetModel:targetModel];

    NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                                          destinationModel:targetModel];

    NSError *error = nil;

    NSAssert(sourceStoreURL, @"Source Store URL required for Migration");
    NSAssert(targetStoreURL, @"Target Store URL required for Migration");

    BOOL success = [migrationManager migrateStoreFromURL:sourceStoreURL
                                                    type:NSSQLiteStoreType
                                                 options:nil
                                        withMappingModel:mappingModel
                                        toDestinationURL:targetStoreURL
                                         destinationType:NSSQLiteStoreType
                                      destinationOptions:nil
                                                   error:&error];
    if (!success)
    {
        //log error
    }
    return success;
}

- (NSMappingModel *) mappingModelAtURL:(NSURL *)mappingModelURL forSourceModel:(NSManagedObjectModel *)sourceModel targetModel:(NSManagedObjectModel *)targetModel;
{
    NSMappingModel *mappingModel = nil;
    if (mappingModelURL)
    {
        mappingModel = [[NSMappingModel alloc] initWithContentsOfURL:mappingModelURL];
    }
    if (mappingModelURL == nil)
    {
        mappingModel = [NSMappingModel mappingModelFromBundles:@[[NSBundle mainBundle]]
                                                forSourceModel:sourceModel
                                              destinationModel:targetModel];
    }
    if (mappingModelURL == nil)
    {
        NSError *error = nil;
        mappingModel = [NSMappingModel inferredMappingModelForSourceModel:sourceModel destinationModel:targetModel error:&error];
        if (mappingModel == nil)
        {
            //log error
        }
    }

    return mappingModel;
}

- (BOOL) MagicalMigrationManager_progressivelyMigrateStoreAtURL:(NSURL *)sourceStoreURL toStoreAtURL:(NSURL *)targetStoreURL ofType:(NSString *)type error:(NSError **)error;
{
    NSManagedObjectModel *targetModel = [self targetModel];
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type
                                                                                              URL:sourceStoreURL
                                                                                            error:error];

    if (nil == sourceMetadata)
    {
        return NO;
    }

    if ([targetModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata])
    {
        if (NULL != error)
        {
            *error = nil;
        }

        return YES;
    }

    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:@[
                                                                                         [NSBundle mainBundle]
                                                                                     ]
                                                                    forStoreMetadata:sourceMetadata];

    NSManagedObjectModel *destinationModel = nil;
    NSMappingModel *mappingModel = nil;
    NSString *modelName = nil;
    if (NO == [self MagicalMigrationManager_getDestinationModel:&destinationModel
                                                   mappingModel:&mappingModel
                                                      modelName:&modelName
                                                 forSourceModel:sourceModel])
    {
        return NO;
    }

    // We have a mapping model, time to migrate
    NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel
                                                                 destinationModel:targetModel];

    if (![manager migrateStoreFromURL:sourceStoreURL
                                 type:type
                              options:nil
                     withMappingModel:mappingModel
                     toDestinationURL:targetStoreURL
                      destinationType:type
                   destinationOptions:nil
                                error:error])
    {
        return NO;
    }

    // Migration was successful, move the files around to preserve the source in case things go bad
    if (![self MagicalMigrationManager_backupSourceStoreAtURL:sourceStoreURL
                                  movingDestinationStoreAtURL:targetStoreURL
                                                        error:error])
    {
        return NO;
    }

    // We may not be at the "current" model yet, so recurse
    return [self MagicalMigrationManager_progressivelyMigrateStoreAtURL:sourceStoreURL
                                                           toStoreAtURL:targetStoreURL
                                                                 ofType:type
                                                                  error:error];
}

- (NSArray *) MagicalMigrationManager_modelPaths;
{
    //Find all of the mom and momd files in the Resources directory
    NSMutableArray *modelPaths = [NSMutableArray array];
    NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd"
                                                            inDirectory:nil];
    for (NSString *momdPath in momdArray)
    {
        NSString *resourceSubpath = [momdPath lastPathComponent];
        NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                            inDirectory:resourceSubpath];
        [modelPaths addObjectsFromArray:array];
    }
    NSArray *otherModels = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom"
                                                              inDirectory:nil];
    [modelPaths addObjectsFromArray:otherModels];
    return modelPaths;
}

- (BOOL) MagicalMigrationManager_getDestinationModel:(NSManagedObjectModel **)destinationModel mappingModel:(NSMappingModel **)mappingModel modelName:(NSString **)modelName forSourceModel:(NSManagedObjectModel *)sourceModel;
{
    NSArray *modelPaths = [self MagicalMigrationManager_modelPaths];
    if ([modelPaths count] == 0)
    {
        return NO;
    }

    // See if we can find a matching destination model
    NSManagedObjectModel *model = nil;
    NSMappingModel *mapping = nil;
    NSString *modelPath = nil;

    for (modelPath in modelPaths)
    {
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
        mapping = [NSMappingModel mappingModelFromBundles:@[
                                                              [NSBundle mainBundle]
                                                          ]
                                           forSourceModel:sourceModel
                                         destinationModel:model];
        // If we found a mapping model then proceed
        if (mapping)
        {
            break;
        }
    }
    // We have tested every model, if nil here we failed
    if (nil == mapping)
    {
        return NO;
    }
    else
    {
        *destinationModel = model;
        *mappingModel = mapping;
        *modelName = [[modelPath lastPathComponent] stringByDeletingPathExtension];
    }

    return YES;
}

- (BOOL) MagicalMigrationManager_backupSourceStoreAtURL:(NSURL *)sourceStoreURL movingDestinationStoreAtURL:(NSURL *)destinationStoreURL error:(NSError **)error;
{
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager moveItemAtPath:sourceStoreURL.path
                              toPath:backupPath
                               error:error])
    {
        // Failed to copy the file
        return NO;
    }
    // Move the destination to the source path
    if (![fileManager moveItemAtPath:destinationStoreURL.path
                              toPath:sourceStoreURL.path
                               error:error])
    {
        // Try to back out the source move first, no point in checking it for errors
        [fileManager moveItemAtPath:backupPath
                             toPath:sourceStoreURL.path
                              error:nil];
        return NO;
    }
    return YES;
}

@end
