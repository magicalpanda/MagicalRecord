//
//  ARCoreDataAction.h
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSManagedObjectContext+MagicalRecord.h"

typedef enum
{
    MRCoreDataSaveOptionInBackground        = 1 << 0,
    MRCoreDataSaveOptionWithNewContext      = 1 << 1
} MRCoreDataSaveOption;

typedef enum
{
    MRCoreDataLookupOptionWithNewContext    = 1 << 0
} MRCoreDataLookupOption;

@interface MRCoreDataAction : NSObject

+ (void) cleanUp;

#ifdef NS_BLOCKS_AVAILABLE

+ (void) saveDataWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

+ (void) saveDataWithOptions:(MRCoreDataSaveOption)options withBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataWithOptions:(MRCoreDataSaveOption)options withBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

+ (void) lookupWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

#endif

@end
