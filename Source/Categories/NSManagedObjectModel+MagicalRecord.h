//
//  NSManagedObjectModel+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MagicalRecordHelpers.h"

@interface NSManagedObjectModel (MagicalRecord)

+ (NSManagedObjectModel *)defaultManagedObjectModel;
+ (void) setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;

+ (NSManagedObjectModel *) newManagedObjectModel;
+ (NSManagedObjectModel *) newManagedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName;

@end

#ifdef MR_SHORTHAND

#define defaultManagedObjectModel               MR_defaultManagedObjectModel
#define setDefaultManagedObjectModel            MR_setDefaultManagedObjectModel
#define newManagedObjectModel                   MR_newManagedObjectModel
#define managedObectModelNamed                  MR_managedObjectModelNamed
#define newModelNamed                           MR_newModelNamed

#endif