//
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (MagicalRecord)

+ (nullable NSManagedObjectModel *)MR_managedObjectModelAtURL:(nonnull NSURL *)url;
+ (nullable NSManagedObjectModel *)MR_mergedObjectModelFromMainBundle;
+ (nonnull NSManagedObjectModel *)MR_managedObjectModelNamed:(nonnull NSString *)modelFileName;
+ (nonnull NSManagedObjectModel *)MR_newModelNamed:(nonnull NSString *)modelName inBundleNamed:(nonnull NSString *)bundleName NS_RETURNS_RETAINED;

@end
