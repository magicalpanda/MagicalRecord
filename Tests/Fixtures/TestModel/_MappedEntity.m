// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.m instead.

#import "_MappedEntity.h"


const struct MappedEntityAttributes MappedEntityAttributes = {
	.mappedEntityID = @"mappedEntityID",
	.nestedAttribute = @"nestedAttribute",
	.sampleAttribute = @"sampleAttribute",
	.testMappedEntityID = @"testMappedEntityID",
};







const struct MappedEntityUserInfo MappedEntityUserInfo = {
	.relatedByAttribute = @"mapped",
};


@implementation MappedEntityID
@end

@implementation _MappedEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MappedEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MappedEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MappedEntity" inManagedObjectContext:moc_];
}

- (MappedEntityID*)objectID {
	return (MappedEntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"mappedEntityIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mappedEntityID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"testMappedEntityIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"testMappedEntityID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic mappedEntityID;



- (int16_t)mappedEntityIDValue {
	NSNumber *result = [self mappedEntityID];
	return [result shortValue];
}


- (void)setMappedEntityIDValue:(int16_t)value_ {
	[self setMappedEntityID:@(value_)];
}


- (int16_t)primitiveMappedEntityIDValue {
	NSNumber *result = [self primitiveMappedEntityID];
	return [result shortValue];
}

- (void)setPrimitiveMappedEntityIDValue:(int16_t)value_ {
	[self setPrimitiveMappedEntityID:@(value_)];
}





@dynamic nestedAttribute;






@dynamic sampleAttribute;






@dynamic testMappedEntityID;



- (int64_t)testMappedEntityIDValue {
	NSNumber *result = [self testMappedEntityID];
	return [result longLongValue];
}


- (void)setTestMappedEntityIDValue:(int64_t)value_ {
	[self setTestMappedEntityID:@(value_)];
}


- (int64_t)primitiveTestMappedEntityIDValue {
	NSNumber *result = [self primitiveTestMappedEntityID];
	return [result longLongValue];
}

- (void)setPrimitiveTestMappedEntityIDValue:(int64_t)value_ {
	[self setPrimitiveTestMappedEntityID:@(value_)];
}










@end




