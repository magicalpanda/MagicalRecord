// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.h instead.

#import <CoreData/CoreData.h>





@interface MappedEntityID : NSManagedObjectID {}
@end

@interface _MappedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MappedEntityID*)objectID;




@property (nonatomic, retain) NSString *sampleAttribute;


//- (BOOL)validateSampleAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _MappedEntity (CoreDataGeneratedAccessors)

@end

@interface _MappedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSampleAttribute;
- (void)setPrimitiveSampleAttribute:(NSString*)value;




@end
