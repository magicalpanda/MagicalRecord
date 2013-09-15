// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.h instead.

#import <CoreData/CoreData.h>



extern const struct MappedEntityAttributes {
	__unsafe_unretained NSString *mappedEntityID;
	__unsafe_unretained NSString *nestedAttribute;
	__unsafe_unretained NSString *sampleAttribute;
	__unsafe_unretained NSString *testMappedEntityID;
} MappedEntityAttributes;







extern const struct MappedEntityUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} MappedEntityUserInfo;












@interface MappedEntityID : NSManagedObjectID {}
@end

@interface _MappedEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MappedEntityID*)objectID;





@property (nonatomic, strong) NSNumber* mappedEntityID;




@property (atomic) int16_t mappedEntityIDValue;
- (int16_t)mappedEntityIDValue;
- (void)setMappedEntityIDValue:(int16_t)value_;


//- (BOOL)validateMappedEntityID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* nestedAttribute;



//- (BOOL)validateNestedAttribute:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sampleAttribute;



//- (BOOL)validateSampleAttribute:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* testMappedEntityID;




@property (atomic) int64_t testMappedEntityIDValue;
- (int64_t)testMappedEntityIDValue;
- (void)setTestMappedEntityIDValue:(int64_t)value_;


//- (BOOL)validateTestMappedEntityID:(id*)value_ error:(NSError**)error_;






@end



@interface _MappedEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveMappedEntityID;
- (void)setPrimitiveMappedEntityID:(NSNumber*)value;

- (int16_t)primitiveMappedEntityIDValue;
- (void)setPrimitiveMappedEntityIDValue:(int16_t)value_;




- (NSString*)primitiveNestedAttribute;
- (void)setPrimitiveNestedAttribute:(NSString*)value;




- (NSString*)primitiveSampleAttribute;
- (void)setPrimitiveSampleAttribute:(NSString*)value;




- (NSNumber*)primitiveTestMappedEntityID;
- (void)setPrimitiveTestMappedEntityID:(NSNumber*)value;

- (int64_t)primitiveTestMappedEntityIDValue;
- (void)setPrimitiveTestMappedEntityIDValue:(int64_t)value_;




@end
