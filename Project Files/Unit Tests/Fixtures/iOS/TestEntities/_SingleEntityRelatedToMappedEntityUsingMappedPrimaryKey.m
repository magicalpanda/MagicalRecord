// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.m instead.

#import "_SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey.h"

const struct SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyAttributes SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyAttributes = {
};

const struct SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyRelationships SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyRelationships = {
	.mappedEntity = @"mappedEntity",
};

const struct SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyFetchedProperties SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyFetchedProperties = {
};

@implementation SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyID
@end

@implementation _SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityRelatedToMappedEntityUsingMappedPrimaryKey" inManagedObjectContext:moc_];
}

- (SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyID*)objectID {
	return (SingleEntityRelatedToMappedEntityUsingMappedPrimaryKeyID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic mappedEntity;

	





@end
