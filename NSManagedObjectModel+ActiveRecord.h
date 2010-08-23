//
//  NSManagedObjectModel+ActiveRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActiveRecordHelpers.h"

@interface NSManagedObjectModel (ActiveRecord)

+ (NSManagedObjectModel *)defaultManagedObjectModel;
+ (void) setDefaultManagedObjectModel:(NSManagedObjectModel *)newDefaultModel;

+ (NSManagedObjectModel *) newManagedObjectModel;
+ (NSManagedObjectModel *) newManagedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *) newModelNamed:(NSString *) modelName inBundleNamed:(NSString *) bundleName;

@end
