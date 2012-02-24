// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleRelatedEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct SingleRelatedEntityAttributes {
} SingleRelatedEntityAttributes;

extern const struct SingleRelatedEntityRelationships {
	 NSString *testRelationship;
} SingleRelatedEntityRelationships;

extern const struct SingleRelatedEntityFetchedProperties {
} SingleRelatedEntityFetchedProperties;

@class ConcreteRelatedEntity;


@interface SingleRelatedEntityID : NSManagedObjectID {}
@end

@interface _SingleRelatedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleRelatedEntityID*)objectID;





@property (nonatomic, retain) ConcreteRelatedEntity* testRelationship;

//- (BOOL)validateTestRelationship:(id*)value_ error:(NSError**)error_;




@end

@interface _SingleRelatedEntity (CoreDataGeneratedAccessors)

@end

@interface _SingleRelatedEntity (CoreDataGeneratedPrimitiveAccessors)



- (ConcreteRelatedEntity*)primitiveTestRelationship;
- (void)setPrimitiveTestRelationship:(ConcreteRelatedEntity*)value;


@end
