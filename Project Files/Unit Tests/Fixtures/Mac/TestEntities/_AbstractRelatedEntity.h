// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AbstractRelatedEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct AbstractRelatedEntityAttributes {
	 NSString *sampleBaseAttribute;
} AbstractRelatedEntityAttributes;

extern const struct AbstractRelatedEntityRelationships {
	 NSString *mainTestEntity;
} AbstractRelatedEntityRelationships;

extern const struct AbstractRelatedEntityFetchedProperties {
} AbstractRelatedEntityFetchedProperties;

@class SingleRelatedEntity;



@interface AbstractRelatedEntityID : NSManagedObjectID {}
@end

@interface _AbstractRelatedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AbstractRelatedEntityID*)objectID;




@property (nonatomic, retain) NSString *sampleBaseAttribute;


//- (BOOL)validateSampleBaseAttribute:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) SingleRelatedEntity* mainTestEntity;

//- (BOOL)validateMainTestEntity:(id*)value_ error:(NSError**)error_;




@end

@interface _AbstractRelatedEntity (CoreDataGeneratedAccessors)

@end

@interface _AbstractRelatedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSampleBaseAttribute;
- (void)setPrimitiveSampleBaseAttribute:(NSString*)value;





- (SingleRelatedEntity*)primitiveMainTestEntity;
- (void)setPrimitiveMainTestEntity:(SingleRelatedEntity*)value;


@end
