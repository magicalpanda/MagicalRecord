// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.m instead.

#import "_SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"

const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyAttributes SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyAttributes = {
	.testPrimaryKey = @"testPrimaryKey",
};

const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyRelationships SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyRelationships = {
	.mappedEntities = @"mappedEntities",
};

const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyFetchedProperties SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyFetchedProperties = {
};

@implementation SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyID
@end

@implementation _SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey" inManagedObjectContext:moc_];
}

- (SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyID*)objectID {
	return (SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"testPrimaryKeyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"testPrimaryKey"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic testPrimaryKey;



- (short)testPrimaryKeyValue {
	NSNumber *result = [self testPrimaryKey];
	return [result shortValue];
}

- (void)setTestPrimaryKeyValue:(short)value_ {
	[self setTestPrimaryKey:[NSNumber numberWithShort:value_]];
}

- (short)primitiveTestPrimaryKeyValue {
	NSNumber *result = [self primitiveTestPrimaryKey];
	return [result shortValue];
}

- (void)setPrimitiveTestPrimaryKeyValue:(short)value_ {
	[self setPrimitiveTestPrimaryKey:[NSNumber numberWithShort:value_]];
}





@dynamic mappedEntities;

	
- (NSMutableSet*)mappedEntitiesSet {
	[self willAccessValueForKey:@"mappedEntities"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mappedEntities"];
  
	[self didAccessValueForKey:@"mappedEntities"];
	return result;
}
	





@end
