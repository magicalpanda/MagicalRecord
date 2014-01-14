// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityRelatedToMappedEntityUsingDefaults.m instead.

#import "_SingleEntityRelatedToMappedEntityUsingDefaults.h"


const struct SingleEntityRelatedToMappedEntityUsingDefaultsAttributes SingleEntityRelatedToMappedEntityUsingDefaultsAttributes = {
	.singleEntityRelatedToMappedEntityUsingDefaultsID = @"singleEntityRelatedToMappedEntityUsingDefaultsID",
};



const struct SingleEntityRelatedToMappedEntityUsingDefaultsRelationships SingleEntityRelatedToMappedEntityUsingDefaultsRelationships = {
	.mappedEntity = @"mappedEntity",
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

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"singleEntityRelatedToMappedEntityUsingDefaultsIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"singleEntityRelatedToMappedEntityUsingDefaultsID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic singleEntityRelatedToMappedEntityUsingDefaultsID;



- (int16_t)singleEntityRelatedToMappedEntityUsingDefaultsIDValue {
	NSNumber *result = [self singleEntityRelatedToMappedEntityUsingDefaultsID];
	return [result shortValue];
}


- (void)setSingleEntityRelatedToMappedEntityUsingDefaultsIDValue:(int16_t)value_ {
	[self setSingleEntityRelatedToMappedEntityUsingDefaultsID:@(value_)];
}


- (int16_t)primitiveSingleEntityRelatedToMappedEntityUsingDefaultsIDValue {
	NSNumber *result = [self primitiveSingleEntityRelatedToMappedEntityUsingDefaultsID];
	return [result shortValue];
}

- (void)setPrimitiveSingleEntityRelatedToMappedEntityUsingDefaultsIDValue:(int16_t)value_ {
	[self setPrimitiveSingleEntityRelatedToMappedEntityUsingDefaultsID:@(value_)];
}





@dynamic mappedEntity;

	






@end




