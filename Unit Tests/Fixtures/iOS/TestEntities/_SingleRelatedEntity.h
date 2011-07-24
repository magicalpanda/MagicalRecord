// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleRelatedEntity.h instead.

#import <CoreData/CoreData.h>


@class AbstractRelatedEntity;


@interface SingleRelatedEntityID : NSManagedObjectID {}
@end

@interface _SingleRelatedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleRelatedEntityID*)objectID;





@property (nonatomic, retain) AbstractRelatedEntity* testRelationship;

//- (BOOL)validateTestRelationship:(id*)value_ error:(NSError**)error_;




@end

@interface _SingleRelatedEntity (CoreDataGeneratedAccessors)

@end

@interface _SingleRelatedEntity (CoreDataGeneratedPrimitiveAccessors)



- (AbstractRelatedEntity*)primitiveTestRelationship;
- (void)setPrimitiveTestRelationship:(AbstractRelatedEntity*)value;


@end
