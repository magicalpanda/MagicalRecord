//
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DifferentClassNameMapping : NSManagedObject

+ (NSString *)entityName;

@end

NS_ASSUME_NONNULL_END

#import "DifferentClassNameMapping+CoreDataProperties.h"
