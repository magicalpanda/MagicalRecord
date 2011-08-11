// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityUsingDefaults.h instead.

#import <CoreData/CoreData.h>


@class MappedEntity;


@interface SingleEntityRelatedToMappedEntityUsingDefaultsID : NSManagedObjectID {}
@end

@interface _SingleEntityRelatedToMappedEntityUsingDefaults : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleEntityRelatedToMappedEntityUsingDefaultsID*)objectID;





@property (nonatomic, retain) MappedEntity* mappedEntity;

//- (BOOL)validateMappedEntity:(id*)value_ error:(NSError**)error_;




@end

@interface _SingleEntityRelatedToMappedEntityUsingDefaults (CoreDataGeneratedAccessors)

@end

@interface _SingleEntityRelatedToMappedEntityUsingDefaults (CoreDataGeneratedPrimitiveAccessors)



- (MappedEntity*)primitiveMappedEntity;
- (void)setPrimitiveMappedEntity:(MappedEntity*)value;


@end
