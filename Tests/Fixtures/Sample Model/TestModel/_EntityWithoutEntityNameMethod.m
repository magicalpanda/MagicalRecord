// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to EntityWithoutEntityNameMethod.m instead.

#import "_EntityWithoutEntityNameMethod.h"

@implementation EntityWithoutEntityNameMethodID
@end

@implementation _EntityWithoutEntityNameMethod

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"EntityWithoutEntityNameMethodWithASuffix" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"EntityWithoutEntityNameMethodWithASuffix";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"EntityWithoutEntityNameMethodWithASuffix" inManagedObjectContext:moc_];
}

- (EntityWithoutEntityNameMethodID*)objectID {
	return (EntityWithoutEntityNameMethodID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@end

