// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AbstractRelatedEntity.h instead.

#import <CoreData/CoreData.h>


@class SingleRelatedEntity;



@interface AbstractRelatedEntityID : NSManagedObjectID {}
@end

@interface _AbstractRelatedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AbstractRelatedEntityID*)objectID;




@property (nonatomic, strong) NSString *sampleBaseAttribute;


//- (BOOL)validateSampleBaseAttribute:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) SingleRelatedEntity* mainTestEntity;

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
