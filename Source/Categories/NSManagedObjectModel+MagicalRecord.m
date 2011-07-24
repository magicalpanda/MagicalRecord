//
//  NSManagedObjectModel+MagicalRecord.m
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

//#import "NSManagedObjectModel+MagicalRecord.h"
#import "CoreData+MagicalRecord.h"


static NSManagedObjectModel *defaultManagedObjectModel_ = nil;

@implementation NSManagedObjectModel (MagicalRecord)


+ (NSManagedObjectModel *)MR_defaultManagedObjectModel
{
	if (defaultManagedObjectModel_ == nil)
	{
		defaultManagedObjectModel_ = [self MR_newManagedObjectModel];
	}
	return defaultManagedObjectModel_;
}

+ (void) MR_setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel
{
	defaultManagedObjectModel_ = newDefaultModel;
}

+ (NSManagedObjectModel *) MR_newManagedObjectModel 
{
    return [NSManagedObjectModel mergedModelFromBundles:nil];
}

+ (NSManagedObjectModel *) MR_newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:[modelName stringByDeletingPathExtension] 
                                                     ofType:[modelName pathExtension] 
                                                inDirectory:bundleName];
    NSURL *modelUrl = [NSURL fileURLWithPath:path];
    
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
}

+ (NSManagedObjectModel *) MR_newManagedObjectModelNamed:(NSString *)modelFileName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:[modelFileName stringByDeletingPathExtension] ofType:[modelFileName pathExtension]];
	NSURL *momURL = [NSURL fileURLWithPath:path];
	
	NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
	return model;
}

+ (NSManagedObjectModel *) MR_managedObjectModelNamed:(NSString *)modelFileName
{
	return [self MR_newManagedObjectModelNamed:modelFileName];
}

@end
