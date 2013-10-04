//
//  MagicalRecord.h
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#if TARGET_OS_IPHONE == 0
#define MAC_PLATFORM_ONLY YES
#endif

#ifdef NS_BLOCKS_AVAILABLE

@class NSManagedObjectContext;
typedef void (^CoreDataBlock)(NSManagedObjectContext *context);

#endif

typedef NS_ENUM(NSInteger, MagicalRecordLogLevel)
{
    MagicalRecordLogLevelOff        = 0,
    MagicalRecordLogLevelFatal      = 1 << 0,
    MagicalRecordLogLevelError      = 1 << 1,
    MagicalRecordLogLevelWarn       = 1 << 2,
    MagicalRecordLogLevelInfo       = 1 << 3,
    MagicalRecordLogLevelVerbose    = 1 << 4,
};

@interface MagicalRecord : NSObject

+ (NSString *) version;
- (NSString *) version;
+ (void) cleanUp;

+ (NSString *) defaultStoreName;

@end
