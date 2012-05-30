// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.m instead.

#import "_MappedEntity.h"

const struct MappedEntityAttributes MappedEntityAttributes = {
	.mappedEntityID = @"mappedEntityID",
	.nestedAttribute = @"nestedAttribute",
	.sampleAttribute = @"sampleAttribute",
	.testMappedEntityID = @"testMappedEntityID",
};

const struct MappedEntityRelationships MappedEntityRelationships = {
};

const struct MappedEntityFetchedProperties MappedEntityFetchedProperties = {
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

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"mappedEntityIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mappedEntityID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"testMappedEntityIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"testMappedEntityID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic mappedEntityID;



- (short)mappedEntityIDValue {
	NSNumber *result = [self mappedEntityID];
	return [result shortValue];
}

- (void)setMappedEntityIDValue:(short)value_ {
	[self setMappedEntityID:[NSNumber numberWithShort:value_]];
}

- (short)primitiveMappedEntityIDValue {
	NSNumber *result = [self primitiveMappedEntityID];
	return [result shortValue];
}

- (void)setPrimitiveMappedEntityIDValue:(short)value_ {
	[self setPrimitiveMappedEntityID:[NSNumber numberWithShort:value_]];
}





@dynamic nestedAttribute;






@dynamic sampleAttribute;






@dynamic testMappedEntityID;



- (long long)testMappedEntityIDValue {
	NSNumber *result = [self testMappedEntityID];
	return [result longLongValue];
}

- (void)setTestMappedEntityIDValue:(long long)value_ {
	[self setTestMappedEntityID:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveTestMappedEntityIDValue {
	NSNumber *result = [self primitiveTestMappedEntityID];
	return [result longLongValue];
}

- (void)setPrimitiveTestMappedEntityIDValue:(long long)value_ {
	[self setPrimitiveTestMappedEntityID:[NSNumber numberWithLongLong:value_]];
}









@end
