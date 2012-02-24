// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DifferentClassNameMapping.m instead.

#import "_DifferentClassNameMapping.h"

const struct DifferentClassNameMappingAttributes DifferentClassNameMappingAttributes = {
};

const struct DifferentClassNameMappingRelationships DifferentClassNameMappingRelationships = {
};

const struct DifferentClassNameMappingFetchedProperties DifferentClassNameMappingFetchedProperties = {
};

@implementation DifferentClassNameMappingID
@end

@implementation _DifferentClassNameMapping

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EntityWithDiffernentClassName" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EntityWithDiffernentClassName";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EntityWithDiffernentClassName" inManagedObjectContext:moc_];
}

- (DifferentClassNameMappingID*)objectID {
	return (DifferentClassNameMappingID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}








@end
