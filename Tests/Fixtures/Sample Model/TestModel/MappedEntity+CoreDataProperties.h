//
//  MappedEntity+CoreDataProperties.h
//  MagicalRecord
//
//  Created by Tony Arnold on 22/11/2015.
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MappedEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MappedEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *mappedEntityID;
@property (nullable, nonatomic, retain) NSString *nestedAttribute;
@property (nullable, nonatomic, retain) NSString *sampleAttribute;
@property (nullable, nonatomic, retain) NSNumber *testMappedEntityID;

@end

NS_ASSUME_NONNULL_END
