//
//  NSManagedObjectModel+MagicalRecord.m
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import "NSManagedObjectModel+MagicalRecord.h"

@implementation NSManagedObjectModel (MagicalRecord)

+ (NSManagedObjectModel *)MR_managedObjectModelAtURL:(NSURL *)url;
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

+ (NSManagedObjectModel *)MR_mergedObjectModelFromMainBundle;
{
    return [self mergedModelFromBundles:nil];
}

+ (NSManagedObjectModel *)MR_newModelNamed:(NSString *)modelName inBundleNamed:(NSString *)bundleName;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[modelName stringByDeletingPathExtension]
                                                     ofType:[modelName pathExtension]
                                                inDirectory:bundleName];
    NSURL *modelUrl = [NSURL fileURLWithPath:path];

    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];

    return mom;
}

+ (NSManagedObjectModel *)MR_managedObjectModelNamed:(NSString *)modelFileName;
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[modelFileName stringByDeletingPathExtension]
                                                     ofType:[modelFileName pathExtension]];
    NSURL *momURL = [NSURL fileURLWithPath:path];

    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    return model;
}

@end
