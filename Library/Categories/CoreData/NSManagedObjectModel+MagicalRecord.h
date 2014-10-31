//
//  NSManagedObjectModel+MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (MagicalRecord)

+ (NSManagedObjectModel *)MR_managedObjectModelAtURL:(NSURL *)url;
+ (NSManagedObjectModel *)MR_mergedObjectModelFromMainBundle;
+ (NSManagedObjectModel *)MR_managedObjectModelNamed:(NSString *)modelFileName;
+ (NSManagedObjectModel *)MR_newModelNamed:(NSString *)modelName inBundleNamed:(NSString *)bundleName NS_RETURNS_RETAINED;

@end
