//
//  NSManagedObjectModel+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecordHelpers.h"

@interface NSManagedObjectModel (MagicalRecord)

+ (NSManagedObjectModel *) MR_defaultManagedObjectModel;
+ (void) MR_setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;

+ (NSManagedObjectModel *) MR_newManagedObjectModel NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_newManagedObjectModelNamed:(NSString *)modelFileName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) MR_newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_mergedObjectModelFromMainBundle;

@end

//
//@interface NSManagedObjectModel (MagicalRecordShortHandHeaders)
//
//+ (NSManagedObjectModel *) defaultManagedObjectModel;
//+ (void) setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;
//
//+ (NSManagedObjectModel *) newManagedObjectModel NS_RETURNS_RETAINED;
//+ (NSManagedObjectModel *) newManagedObjectModelNamed:(NSString *)modelFileName NS_RETURNS_RETAINED;
//+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
//+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;
//+ (NSManagedObjectModel *) mergedObjectModelFromMainBundle;
//
//@end
