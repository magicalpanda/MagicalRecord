//
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.

#import "NSManagedObjectModel+MagicalRecord.h"

@implementation NSManagedObjectModel (MagicalRecord)

+ (nullable NSManagedObjectModel *)MR_managedObjectModelAtURL:(nonnull NSURL *)url
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

+ (nullable NSManagedObjectModel *)MR_mergedObjectModelFromMainBundle
{
    return [self mergedModelFromBundles:nil];
}

+ (nonnull NSManagedObjectModel *)MR_newModelNamed:(nonnull NSString *)modelName inBundleNamed:(nonnull NSString *)bundleName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[modelName stringByDeletingPathExtension] ofType:[modelName pathExtension] inDirectory:bundleName];
    NSURL *modelUrl = [NSURL fileURLWithPath:path];

    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];

    return mom;
}

+ (nonnull NSManagedObjectModel *)MR_managedObjectModelNamed:(nonnull NSString *)modelFileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[modelFileName stringByDeletingPathExtension] ofType:[modelFileName pathExtension]];
    NSURL *momURL = [NSURL fileURLWithPath:path];

    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return model;
}

@end
