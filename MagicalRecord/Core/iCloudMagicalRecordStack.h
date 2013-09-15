//
//  iCloudMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/14/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"

@interface iCloudMagicalRecordStack : MagicalRecordStack

@property (nonatomic, copy) NSString *containerID;
@property (nonatomic, copy) NSString *contentNameKey;
@property (nonatomic, copy) NSString *cloudStorePathComponent;
@property (nonatomic, copy) NSString *localStoreName;

@property (nonatomic, copy) void (^setupCompletionBlock)(void);

- (instancetype) initWithContainerID:(NSString *)containerID localStoreName:(NSString *)localStoreName;
- (instancetype) initWithContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreName:(NSString *)localStoreName;
- (instancetype) initWithContainerID:(NSString *)containerID contentNameKey:(NSString *)contentNameKey cloudStorePathComponent:(NSString *)cloudStorePathComponent localStoreName:(NSString *)localStoreName;

@end
