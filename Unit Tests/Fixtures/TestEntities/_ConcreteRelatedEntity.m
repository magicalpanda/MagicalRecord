// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ConcreteRelatedEntity.m instead.

#import "_ConcreteRelatedEntity.h"

@implementation ConcreteRelatedEntityID
@end

@implementation _ConcreteRelatedEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ConcreteRelatedEntity" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ConcreteRelatedEntity";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ConcreteRelatedEntity" inManagedObjectContext:moc_];
}

- (ConcreteRelatedEntityID*)objectID {
	return (ConcreteRelatedEntityID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic sampleConcreteAttribute;










@end
