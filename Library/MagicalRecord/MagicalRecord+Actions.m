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

/**
 *  Synchronously saves the default managed object context (if there is one) and any parent contexts.
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 *
 *  @return Success state of the save operation
 */
+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;
{
    return [self saveWithBlockAndWait:block error:nil];
}

/**
 *  Synchronously saves the default managed object context (if there is one) and any parent contexts.
 *
 *  @param block Make changes to CoreData objects in this block using the passed in localContext. The block will be performed on a background queue, and once complete, the context will be saved.
 *  @param error Pass in an NSError by reference to receive any errors encountered during the save.
 *
 *  @return Success state of the save operation
 */
+ (BOOL) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block error:(NSError **)error
{
    return [[MagicalRecordStack defaultStack] saveWithBlockAndWait:block error:error];
}

@end
