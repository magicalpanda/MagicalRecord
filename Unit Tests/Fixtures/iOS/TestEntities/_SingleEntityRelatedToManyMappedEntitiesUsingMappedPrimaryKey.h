// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h instead.

#import <CoreData/CoreData.h>


@class MappedEntity;


@interface SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyID : NSManagedObjectID {}
@end

@interface _SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyID*)objectID;





@property (nonatomic, retain) NSSet* mappedEntities;

- (NSMutableSet*)mappedEntitiesSet;




@end

@interface _SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey (CoreDataGeneratedAccessors)

- (void)addMappedEntities:(NSSet*)value_;
- (void)removeMappedEntities:(NSSet*)value_;
- (void)addMappedEntitiesObject:(MappedEntity*)value_;
- (void)removeMappedEntitiesObject:(MappedEntity*)value_;

@end

@interface _SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitiveMappedEntities;
- (void)setPrimitiveMappedEntities:(NSMutableSet*)value;


@end
