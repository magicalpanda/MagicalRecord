//
//  Created by Tony Arnold on 20/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

@import Foundation;
@import CoreData;

@protocol MagicalRecordMOGeneratorProtocol <NSObject>

@optional
+ (NSString *)entityName;
- (instancetype)entityInManagedObjectContext:(NSManagedObjectContext *)object;
- (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)object;

@end
