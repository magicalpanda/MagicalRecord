//
//  MagicalRecord+Actions.m
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord+Actions.h"
#import "MagicalRecordStack+Actions.h"

@implementation MagicalRecord (Actions)

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;
{
    [[MagicalRecordStack defaultStack] saveWithBlock:block];
}

+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;
{
    [[MagicalRecordStack defaultStack] saveWithBlock:block completion:completion];
}

+ (void) saveWithBlock:(void (^)(NSManagedObjectContext *))block identifier:(NSString *)contextWorkingName completion:(MRSaveCompletionHandler)completion;
{
    [[MagicalRecordStack defaultStack] saveWithBlock:block identifier:contextWorkingName completion:completion];
}

+ (void) saveWithIdentifier:(NSString *)identifier block:(void(^)(NSManagedObjectContext *))block;
{
    [[MagicalRecordStack defaultStack] saveWithIdentifier:identifier block:block];
}

+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    return [self saveWithBlockAndWait:block error:nil];
}

+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block error:(NSError **)error
{
    return [[MagicalRecordStack defaultStack] saveWithBlockAndWait:block error:error];
}

@end
