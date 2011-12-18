// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityWithNoRelationships.h instead.

#import <CoreData/CoreData.h>


extern const struct SingleEntityWithNoRelationshipsAttributes {
	__unsafe_unretained NSString *booleanTestAttribute;
	__unsafe_unretained NSString *colorTestAttribute;
	__unsafe_unretained NSString *dateTestAttribute;
	__unsafe_unretained NSString *dateWithCustomFormat;
	__unsafe_unretained NSString *decimalTestAttribute;
	__unsafe_unretained NSString *doubleTestAttribute;
	__unsafe_unretained NSString *floatTestAttribute;
	__unsafe_unretained NSString *int16TestAttribute;
	__unsafe_unretained NSString *int32TestAttribute;
	__unsafe_unretained NSString *int64TestAttribute;
	__unsafe_unretained NSString *mappedStringAttribute;
	__unsafe_unretained NSString *notInJsonAttribute;
	__unsafe_unretained NSString *nullTestAttribute;
	__unsafe_unretained NSString *stringTestAttribute;
} SingleEntityWithNoRelationshipsAttributes;

extern const struct SingleEntityWithNoRelationshipsRelationships {
} SingleEntityWithNoRelationshipsRelationships;

extern const struct SingleEntityWithNoRelationshipsFetchedProperties {
} SingleEntityWithNoRelationshipsFetchedProperties;



@class UIColor;













@interface SingleEntityWithNoRelationshipsID : NSManagedObjectID {}
@end

@interface _SingleEntityWithNoRelationships : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SingleEntityWithNoRelationshipsID*)objectID;




@property (nonatomic, strong) NSNumber *booleanTestAttribute;


@property BOOL booleanTestAttributeValue;
- (BOOL)booleanTestAttributeValue;
- (void)setBooleanTestAttributeValue:(BOOL)value_;

//- (BOOL)validateBooleanTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) UIColor *colorTestAttribute;


//- (BOOL)validateColorTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateTestAttribute;


//- (BOOL)validateDateTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDate *dateWithCustomFormat;


//- (BOOL)validateDateWithCustomFormat:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSDecimalNumber *decimalTestAttribute;


//- (BOOL)validateDecimalTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *doubleTestAttribute;


@property double doubleTestAttributeValue;
- (double)doubleTestAttributeValue;
- (void)setDoubleTestAttributeValue:(double)value_;

//- (BOOL)validateDoubleTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *floatTestAttribute;


@property float floatTestAttributeValue;
- (float)floatTestAttributeValue;
- (void)setFloatTestAttributeValue:(float)value_;

//- (BOOL)validateFloatTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *int16TestAttribute;


@property short int16TestAttributeValue;
- (short)int16TestAttributeValue;
- (void)setInt16TestAttributeValue:(short)value_;

//- (BOOL)validateInt16TestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *int32TestAttribute;


@property int int32TestAttributeValue;
- (int)int32TestAttributeValue;
- (void)setInt32TestAttributeValue:(int)value_;

//- (BOOL)validateInt32TestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *int64TestAttribute;


@property long long int64TestAttributeValue;
- (long long)int64TestAttributeValue;
- (void)setInt64TestAttributeValue:(long long)value_;

//- (BOOL)validateInt64TestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *mappedStringAttribute;


//- (BOOL)validateMappedStringAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *notInJsonAttribute;


//- (BOOL)validateNotInJsonAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSNumber *nullTestAttribute;


@property long long nullTestAttributeValue;
- (long long)nullTestAttributeValue;
- (void)setNullTestAttributeValue:(long long)value_;

//- (BOOL)validateNullTestAttribute:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSString *stringTestAttribute;


//- (BOOL)validateStringTestAttribute:(id*)value_ error:(NSError**)error_;





@end

@interface _SingleEntityWithNoRelationships (CoreDataGeneratedAccessors)

@end

@interface _SingleEntityWithNoRelationships (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveBooleanTestAttribute;
- (void)setPrimitiveBooleanTestAttribute:(NSNumber*)value;

- (BOOL)primitiveBooleanTestAttributeValue;
- (void)setPrimitiveBooleanTestAttributeValue:(BOOL)value_;




- (UIColor*)primitiveColorTestAttribute;
- (void)setPrimitiveColorTestAttribute:(UIColor*)value;




- (NSDate*)primitiveDateTestAttribute;
- (void)setPrimitiveDateTestAttribute:(NSDate*)value;




- (NSDate*)primitiveDateWithCustomFormat;
- (void)setPrimitiveDateWithCustomFormat:(NSDate*)value;




- (NSDecimalNumber*)primitiveDecimalTestAttribute;
- (void)setPrimitiveDecimalTestAttribute:(NSDecimalNumber*)value;




- (NSNumber*)primitiveDoubleTestAttribute;
- (void)setPrimitiveDoubleTestAttribute:(NSNumber*)value;

- (double)primitiveDoubleTestAttributeValue;
- (void)setPrimitiveDoubleTestAttributeValue:(double)value_;




- (NSNumber*)primitiveFloatTestAttribute;
- (void)setPrimitiveFloatTestAttribute:(NSNumber*)value;

- (float)primitiveFloatTestAttributeValue;
- (void)setPrimitiveFloatTestAttributeValue:(float)value_;




- (NSNumber*)primitiveInt16TestAttribute;
- (void)setPrimitiveInt16TestAttribute:(NSNumber*)value;

- (short)primitiveInt16TestAttributeValue;
- (void)setPrimitiveInt16TestAttributeValue:(short)value_;




- (NSNumber*)primitiveInt32TestAttribute;
- (void)setPrimitiveInt32TestAttribute:(NSNumber*)value;

- (int)primitiveInt32TestAttributeValue;
- (void)setPrimitiveInt32TestAttributeValue:(int)value_;




- (NSNumber*)primitiveInt64TestAttribute;
- (void)setPrimitiveInt64TestAttribute:(NSNumber*)value;

- (long long)primitiveInt64TestAttributeValue;
- (void)setPrimitiveInt64TestAttributeValue:(long long)value_;




- (NSString*)primitiveMappedStringAttribute;
- (void)setPrimitiveMappedStringAttribute:(NSString*)value;




- (NSString*)primitiveNotInJsonAttribute;
- (void)setPrimitiveNotInJsonAttribute:(NSString*)value;




- (NSNumber*)primitiveNullTestAttribute;
- (void)setPrimitiveNullTestAttribute:(NSNumber*)value;

- (long long)primitiveNullTestAttributeValue;
- (void)setPrimitiveNullTestAttributeValue:(long long)value_;




- (NSString*)primitiveStringTestAttribute;
- (void)setPrimitiveStringTestAttribute:(NSString*)value;




@end
