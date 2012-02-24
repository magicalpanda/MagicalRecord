// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityWithNestedMappedAttributes.m instead.

#import "_SingleEntityRelatedToMappedEntityWithNestedMappedAttributes.h"

const struct SingleEntityRelatedToMappedEntityWithNestedMappedAttributesAttributes SingleEntityRelatedToMappedEntityWithNestedMappedAttributesAttributes = {
};

const struct SingleEntityRelatedToMappedEntityWithNestedMappedAttributesRelationships SingleEntityRelatedToMappedEntityWithNestedMappedAttributesRelationships = {
	.mappedEntity = @"mappedEntity",
};

const struct SingleEntityRelatedToMappedEntityWithNestedMappedAttributesFetchedProperties SingleEntityRelatedToMappedEntityWithNestedMappedAttributesFetchedProperties = {
};

@implementation SingleEntityRelatedToMappedEntityWithNestedMappedAttributesID
@end

@implementation _SingleEntityRelatedToMappedEntityWithNestedMappedAttributes

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityRelatedToMappedEntityWithNestedMappedAttributes" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityRelatedToMappedEntityWithNestedMappedAttributes";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityRelatedToMappedEntityWithNestedMappedAttributes" inManagedObjectContext:moc_];
}

- (SingleEntityRelatedToMappedEntityWithNestedMappedAttributesID*)objectID {
	return (SingleEntityRelatedToMappedEntityWithNestedMappedAttributesID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic mappedEntity;

	





@end
