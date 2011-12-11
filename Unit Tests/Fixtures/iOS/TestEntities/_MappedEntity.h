// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct MappedEntityAttributes {
	__unsafe_unretained NSString *mappedEntityID;
	__unsafe_unretained NSString *nestedAttribute;
	__unsafe_unretained NSString *sampleAttribute;
	__unsafe_unretained NSString *testMappedEntityID;
} MappedEntityAttributes;

extern const struct MappedEntityRelationships {
} MappedEntityRelationships;

extern const struct MappedEntityFetchedProperties {
} MappedEntityFetchedProperties;







@interface MappedEntityID : NSManagedObjectID {}
@end

@interface _MappedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MappedEntityID*)objectID;




@property (nonatomic, strong) NSNumber *mappedEntityID;


@property short mappedEntityIDValue;
- (short)mappedEntityIDValue;
- (void)setMappedEntityIDValue:(short)value_;

//- (BOOL)validateMappedEntityID:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *nestedAttribute;


//- (BOOL)validateNestedAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *sampleAttribute;


//- (BOOL)validateSampleAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *testMappedEntityID;


@property long long testMappedEntityIDValue;
- (long long)testMappedEntityIDValue;
- (void)setTestMappedEntityIDValue:(long long)value_;

//- (BOOL)validateTestMappedEntityID:(id*)value_ error:(NSError**)error_;





@end

@interface _MappedEntity (CoreDataGeneratedAccessors)

@end

@interface _MappedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveMappedEntityID;
- (void)setPrimitiveMappedEntityID:(NSNumber*)value;

- (short)primitiveMappedEntityIDValue;
- (void)setPrimitiveMappedEntityIDValue:(short)value_;




- (NSString*)primitiveNestedAttribute;
- (void)setPrimitiveNestedAttribute:(NSString*)value;




- (NSString*)primitiveSampleAttribute;
- (void)setPrimitiveSampleAttribute:(NSString*)value;




- (NSNumber*)primitiveTestMappedEntityID;
- (void)setPrimitiveTestMappedEntityID:(NSNumber*)value;

- (long long)primitiveTestMappedEntityIDValue;
- (void)setPrimitiveTestMappedEntityIDValue:(long long)value_;




@end
