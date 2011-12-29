// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ConcreteRelatedEntity.h instead.

#import <CoreData/CoreData.h>
#import "AbstractRelatedEntity.h"




@interface ConcreteRelatedEntityID : NSManagedObjectID {}
@end

@interface _ConcreteRelatedEntity : AbstractRelatedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ConcreteRelatedEntityID*)objectID;




@property (nonatomic, retain) NSString *sampleConcreteAttribute;


//- (BOOL)validateSampleConcreteAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _ConcreteRelatedEntity (CoreDataGeneratedAccessors)

@end

@interface _ConcreteRelatedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSampleConcreteAttribute;
- (void)setPrimitiveSampleConcreteAttribute:(NSString*)value;




@end
