//
//  NSManagedObjectModel+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecordHelpers.h"

@interface NSManagedObjectModel (MagicalRecord)

+ (NSManagedObjectModel *)MR_defaultManagedObjectModel;
+ (void) MR_setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;

+ (NSManagedObjectModel *) MR_newManagedObjectModel NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_newManagedObjectModelNamed:(NSString *)modelFileName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) MR_newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName NS_RETURNS_RETAINED;
+ (NSManagedObjectModel *) MR_mergedObjectModelFromMainBundle;

@end


#ifdef MR_SHORTHAND

#define defaultManagedObjectModel               MR_defaultManagedObjectModel
#define setDefaultManagedObjectModel            MR_setDefaultManagedObjectModel
#define newManagedObjectModel                   MR_newManagedObjectModel
#define managedObjectModelNamed                 MR_managedObjectModelNamed
#define newModelNamed                           MR_newModelNamed

#endif
