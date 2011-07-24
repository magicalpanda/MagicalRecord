// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleRelatedEntity.m instead.

#import "_SingleRelatedEntity.h"

@implementation SingleRelatedEntityID
@end

@implementation _SingleRelatedEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleRelatedEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleRelatedEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleRelatedEntity" inManagedObjectContext:moc_];
}

- (SingleRelatedEntityID*)objectID {
	return (SingleRelatedEntityID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic testRelationship;

	





@end
