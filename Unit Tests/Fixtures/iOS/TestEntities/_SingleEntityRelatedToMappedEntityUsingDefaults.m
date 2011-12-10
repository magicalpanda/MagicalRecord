// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityUsingDefaults.m instead.

#import "_SingleEntityRelatedToMappedEntityUsingDefaults.h"

const struct SingleEntityRelatedToMappedEntityUsingDefaultsAttributes SingleEntityRelatedToMappedEntityUsingDefaultsAttributes = {
	.singleEntityRelatedToMappedEntityUsingDefaultsID = @"singleEntityRelatedToMappedEntityUsingDefaultsID",
};

const struct SingleEntityRelatedToMappedEntityUsingDefaultsRelationships SingleEntityRelatedToMappedEntityUsingDefaultsRelationships = {
	.mappedEntity = @"mappedEntity",
};

const struct SingleEntityRelatedToMappedEntityUsingDefaultsFetchedProperties SingleEntityRelatedToMappedEntityUsingDefaultsFetchedProperties = {
};

@implementation SingleEntityRelatedToMappedEntityUsingDefaultsID
@end

@implementation _SingleEntityRelatedToMappedEntityUsingDefaults

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityRelatedToMappedEntityUsingDefaults" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityRelatedToMappedEntityUsingDefaults";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityRelatedToMappedEntityUsingDefaults" inManagedObjectContext:moc_];
}

- (SingleEntityRelatedToMappedEntityUsingDefaultsID*)objectID {
	return (SingleEntityRelatedToMappedEntityUsingDefaultsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"singleEntityRelatedToMappedEntityUsingDefaultsIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"singleEntityRelatedToMappedEntityUsingDefaultsID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic singleEntityRelatedToMappedEntityUsingDefaultsID;



- (short)singleEntityRelatedToMappedEntityUsingDefaultsIDValue {
	NSNumber *result = [self singleEntityRelatedToMappedEntityUsingDefaultsID];
	return [result shortValue];
}

- (void)setSingleEntityRelatedToMappedEntityUsingDefaultsIDValue:(short)value_ {
	[self setSingleEntityRelatedToMappedEntityUsingDefaultsID:[NSNumber numberWithShort:value_]];
}

- (short)primitiveSingleEntityRelatedToMappedEntityUsingDefaultsIDValue {
	NSNumber *result = [self primitiveSingleEntityRelatedToMappedEntityUsingDefaultsID];
	return [result shortValue];
}

- (void)setPrimitiveSingleEntityRelatedToMappedEntityUsingDefaultsIDValue:(short)value_ {
	[self setPrimitiveSingleEntityRelatedToMappedEntityUsingDefaultsID:[NSNumber numberWithShort:value_]];
}





@dynamic mappedEntity;

	





@end
