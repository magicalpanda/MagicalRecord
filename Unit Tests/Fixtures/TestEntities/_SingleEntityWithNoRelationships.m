// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SingleEntityWithNoRelationships.m instead.

#import "_SingleEntityWithNoRelationships.h"

@implementation SingleEntityWithNoRelationshipsID
@end

@implementation _SingleEntityWithNoRelationships

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SingleEntityWithNoRelationships" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SingleEntityWithNoRelationships";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SingleEntityWithNoRelationships" inManagedObjectContext:moc_];
}

- (SingleEntityWithNoRelationshipsID*)objectID {
	return (SingleEntityWithNoRelationshipsID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"integerTestAttributeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"integerTestAttribute"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic integerTestAttribute;



- (long long)integerTestAttributeValue {
	NSNumber *result = [self integerTestAttribute];
	return [result longLongValue];
}

- (void)setIntegerTestAttributeValue:(long long)value_ {
	[self setIntegerTestAttribute:[NSNumber numberWithLongLong:value_]];
}

- (long long)primitiveIntegerTestAttributeValue {
	NSNumber *result = [self primitiveIntegerTestAttribute];
	return [result longLongValue];
}

- (void)setPrimitiveIntegerTestAttributeValue:(long long)value_ {
	[self setPrimitiveIntegerTestAttribute:[NSNumber numberWithLongLong:value_]];
}





@dynamic stringTestAttribute;










@end
