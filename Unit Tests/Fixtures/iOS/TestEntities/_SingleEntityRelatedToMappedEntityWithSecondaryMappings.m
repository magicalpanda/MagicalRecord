// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityWithSecondaryMappings.m instead.

#import "_SingleEntityRelatedToMappedEntityWithSecondaryMappings.h"

const struct SingleEntityRelatedToMappedEntityWithSecondaryMappingsAttributes SingleEntityRelatedToMappedEntityWithSecondaryMappingsAttributes = {
	.secondaryMappedAttribute = @"secondaryMappedAttribute",
};

const struct SingleEntityRelatedToMappedEntityWithSecondaryMappingsRelationships SingleEntityRelatedToMappedEntityWithSecondaryMappingsRelationships = {
	.mappedRelationship = @"mappedRelationship",
};

const struct SingleEntityRelatedToMappedEntityWithSecondaryMappingsFetchedProperties SingleEntityRelatedToMappedEntityWithSecondaryMappingsFetchedProperties = {
};

@implementation SingleEntityRelatedToMappedEntityWithSecondaryMappingsID
@end

@implementation _SingleEntityRelatedToMappedEntityWithSecondaryMappings

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityRelatedToMappedEntityWithSecondaryMappings" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityRelatedToMappedEntityWithSecondaryMappings";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityRelatedToMappedEntityWithSecondaryMappings" inManagedObjectContext:moc_];
}

- (SingleEntityRelatedToMappedEntityWithSecondaryMappingsID*)objectID {
	return (SingleEntityRelatedToMappedEntityWithSecondaryMappingsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic secondaryMappedAttribute;






@dynamic mappedRelationship;

	





@end
