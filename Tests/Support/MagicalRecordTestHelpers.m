//
//  Copyright (c) 2015 Magical Panda Software LLC. All rights reserved.

#import "MagicalRecordTestHelpers.h"

@implementation MagicalRecordTestHelpers

+ (BOOL)removeStoreFilesForStoreAtURL:(NSURL *)storeURL
{
    NSString *rawURL = [storeURL absoluteString];
    NSURL *shmSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-shm"]];
    NSURL *walSidecar = [NSURL URLWithString:[rawURL stringByAppendingString:@"-wal"]];

    BOOL success = YES;
    success &= [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    success &= [[NSFileManager defaultManager] removeItemAtURL:shmSidecar error:nil];
    success &= [[NSFileManager defaultManager] removeItemAtURL:walSidecar error:nil];

    return success;
}


@end
