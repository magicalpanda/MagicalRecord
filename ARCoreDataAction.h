//
//  ARCoreDataAction.h
//  Freshpod
//
//  Created by Saul Mora on 2/24/11.
//  Copyright 2011 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ARCoreDataSaveOptionInBackground        = 1 << 0,
    ARCoreDataSaveOptionWithNewContext      = 1 << 1
} ARCoreDataSaveOption;

typedef enum
{
    ARCoreDataLookupOptionWithNewContext    = 1 << 0
} ARCoreDataLookupOption;

@interface ARCoreDataAction : NSObject {}

#ifdef NS_BLOCKS_AVAILABLE

+ (void) saveDataWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

+ (void) saveDataWithOptions:(ARCoreDataSaveOption)options withBlock:(void(^)(NSManagedObjectContext *localContext))block;
+ (void) saveDataWithOptions:(ARCoreDataSaveOption)options withBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))callback;

+ (void) lookupWithBlock:(void(^)(NSManagedObjectContext *localContext))block;

#endif


@end
