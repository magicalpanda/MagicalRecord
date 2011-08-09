// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MappedEntity.m instead.

#import "_MappedEntity.h"

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
	

	return keyPaths;
}




@dynamic sampleAttribute;










@end
