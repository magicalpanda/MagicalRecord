//
//  SingleRelatedEntity+CoreDataProperties.h
//  MagicalRecord
//
//  Created by Tony Arnold on 22/11/2015.
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SingleRelatedEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SingleRelatedEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *mappedStringAttribute;
@property (nullable, nonatomic, retain) NSSet<AbstractRelatedEntity *> *testAbstractToManyRelationship;
@property (nullable, nonatomic, retain) AbstractRelatedEntity *testAbstractToOneRelationship;
@property (nullable, nonatomic, retain) NSSet<ConcreteRelatedEntity *> *testConcreteToManyRelationship;
@property (nullable, nonatomic, retain) ConcreteRelatedEntity *testConcreteToOneRelationship;

@end

@interface SingleRelatedEntity (CoreDataGeneratedAccessors)

- (void)addTestAbstractToManyRelationshipObject:(AbstractRelatedEntity *)value;
- (void)removeTestAbstractToManyRelationshipObject:(AbstractRelatedEntity *)value;
- (void)addTestAbstractToManyRelationship:(NSSet<AbstractRelatedEntity *> *)values;
- (void)removeTestAbstractToManyRelationship:(NSSet<AbstractRelatedEntity *> *)values;

- (void)addTestConcreteToManyRelationshipObject:(ConcreteRelatedEntity *)value;
- (void)removeTestConcreteToManyRelationshipObject:(ConcreteRelatedEntity *)value;
- (void)addTestConcreteToManyRelationship:(NSSet<ConcreteRelatedEntity *> *)values;
- (void)removeTestConcreteToManyRelationship:(NSSet<ConcreteRelatedEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
