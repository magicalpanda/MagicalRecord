// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityWithNoRelationships.h instead.

#import <CoreData/CoreData.h>






@interface SingleEntityWithNoRelationshipsID : NSManagedObjectID {}
@end

@interface _SingleEntityWithNoRelationships : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleEntityWithNoRelationshipsID*)objectID;




@property (nonatomic, retain) NSNumber *integerTestAttribute;


@property long long integerTestAttributeValue;
- (long long)integerTestAttributeValue;
- (void)setIntegerTestAttributeValue:(long long)value_;

//- (BOOL)validateIntegerTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString *stringTestAttribute;


//- (BOOL)validateStringTestAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _SingleEntityWithNoRelationships (CoreDataGeneratedAccessors)

@end

@interface _SingleEntityWithNoRelationships (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIntegerTestAttribute;
- (void)setPrimitiveIntegerTestAttribute:(NSNumber*)value;

- (long long)primitiveIntegerTestAttributeValue;
- (void)setPrimitiveIntegerTestAttributeValue:(long long)value_;




- (NSString*)primitiveStringTestAttribute;
- (void)setPrimitiveStringTestAttribute:(NSString*)value;




@end
