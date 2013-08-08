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

@end
