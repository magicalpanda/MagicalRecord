//
//  SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey+CoreDataProperties.h
//  MagicalRecord
//
//  Created by Tony Arnold on 22/11/2015.
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *testPrimaryKey;
@property (nullable, nonatomic, retain) NSSet<MappedEntity *> *mappedEntities;

@end

@interface SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey (CoreDataGeneratedAccessors)

- (void)addMappedEntitiesObject:(MappedEntity *)value;
- (void)removeMappedEntitiesObject:(MappedEntity *)value;
- (void)addMappedEntities:(NSSet<MappedEntity *> *)values;
- (void)removeMappedEntities:(NSSet<MappedEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
