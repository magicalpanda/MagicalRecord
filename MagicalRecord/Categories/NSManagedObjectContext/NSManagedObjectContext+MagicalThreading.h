//
//  NSManagedObjectContext+MagicalThreading.h
//  Magical Record
//
//  Created by Saul Mora on 3/9/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

#if __has_include(<MagicalRecord/MagicalRecord.h>)
#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>
#else
#import "MagicalRecordXcode7CompatibilityMacros.h"
#endif

@interface NSManagedObjectContext (MagicalThreading)

+ (MR_nonnull NSManagedObjectContext *) MR_contextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) MR_clearNonMainThreadContextsCache __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) MR_resetContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));
+ (void) MR_clearContextForCurrentThread __attribute((deprecated("This method will be removed in MagicalRecord 3.0")));

@end
