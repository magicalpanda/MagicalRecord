// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.m instead.

#import "_SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKey.h"


const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyAttributes SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyAttributes = {
	.testPrimaryKey = @"testPrimaryKey",
};



const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyRelationships SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyRelationships = {
	.mappedEntities = @"mappedEntities",
};





const struct SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyUserInfo SingleEntityRelatedToManyMappedEntitiesUsingMappedPrimaryKeyUserInfo = {
	.relatedByAttribute = @"testPrimaryKey",
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"testPrimaryKeyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"testPrimaryKey"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic testPrimaryKey;



- (int16_t)testPrimaryKeyValue {
	NSNumber *result = [self testPrimaryKey];
	return [result shortValue];
}


- (void)setTestPrimaryKeyValue:(int16_t)value_ {
	[self setTestPrimaryKey:@(value_)];
}


- (int16_t)primitiveTestPrimaryKeyValue {
	NSNumber *result = [self primitiveTestPrimaryKey];
	return [result shortValue];
}

- (void)setPrimitiveTestPrimaryKeyValue:(int16_t)value_ {
	[self setPrimitiveTestPrimaryKey:@(value_)];
}





@dynamic mappedEntities;

	
- (NSMutableSet*)mappedEntitiesSet {
	[self willAccessValueForKey:@"mappedEntities"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"mappedEntities"];
  
	[self didAccessValueForKey:@"mappedEntities"];
	return result;
}
	






@end




