//
//  SQLiteMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"

@interface SQLiteMagicalRecordStack : MagicalRecordStack

@property (nonatomic, copy, readonly) NSURL *storeURL;

- (instancetype) initWithStoreNamed:(NSString *)name;
- (instancetype) initWithStoreAtURL:(NSURL *)url;
- (instancetype) initWithStoreAtPath:(NSString *)path;

@end
