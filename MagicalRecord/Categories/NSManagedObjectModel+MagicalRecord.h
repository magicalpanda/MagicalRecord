//
//  NSManagedObjectModel+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>
#import "MagicalRecordXcode7CompatibilityMacros.h"

@interface NSManagedObjectModel (MagicalRecord)

+ (MR_nullable NSManagedObjectModel *) MR_defaultManagedObjectModel;

+ (void) MR_setDefaultManagedObjectModel:(MR_nullable NSManagedObjectModel *)newDefaultModel;

+ (MR_nullable NSManagedObjectModel *) MR_mergedObjectModelFromMainBundle;
+ (MR_nullable NSManagedObjectModel *) MR_newManagedObjectModelNamed:(MR_nonnull NSString *)modelFileName NS_RETURNS_RETAINED;
+ (MR_nullable NSManagedObjectModel *) MR_managedObjectModelNamed:(MR_nonnull NSString *)modelFileName;
+ (MR_nullable NSManagedObjectModel *) MR_newModelNamed:(MR_nonnull NSString *) modelName inBundleNamed:(MR_nonnull NSString *) bundleName NS_RETURNS_RETAINED;
+ (MR_nullable NSManagedObjectModel *) MR_newModelNamed:(MR_nonnull NSString *) modelName inBundle:(MR_nonnull NSBundle*) bundle NS_RETURNS_RETAINED;

@end
