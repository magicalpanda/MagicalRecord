// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityWithNestedMappedAttributes.h instead.

#import <CoreData/CoreData.h>


@class MappedEntity;


@interface SingleEntityRelatedToMappedEntityWithNestedMappedAttributesID : NSManagedObjectID {}
@end

@interface _SingleEntityRelatedToMappedEntityWithNestedMappedAttributes : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleEntityRelatedToMappedEntityWithNestedMappedAttributesID*)objectID;





@property (nonatomic, retain) MappedEntity* mappedEntity;

//- (BOOL)validateMappedEntity:(id*)value_ error:(NSError**)error_;




@end

@interface _SingleEntityRelatedToMappedEntityWithNestedMappedAttributes (CoreDataGeneratedAccessors)

@end

@interface _SingleEntityRelatedToMappedEntityWithNestedMappedAttributes (CoreDataGeneratedPrimitiveAccessors)



- (MappedEntity*)primitiveMappedEntity;
- (void)setPrimitiveMappedEntity:(MappedEntity*)value;


@end
