//
//  NSManagedObject+MagicalDataImport.m
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"
#import "MagicalRecord.h"
#import "NSObject+MagicalDataImport.h"
#import "MagicalRecordLogging.h"

void MR_swapMethodsFromClass(Class c, SEL orig, SEL new);

NSString *const kMagicalRecordImportCustomDateFormatKey = @"dateFormat";
NSString *const kMagicalRecordImportDefaultDateFormatString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString *const kMagicalRecordImportUnixTimeString = @"UnixTime";

NSString *const kMagicalRecordImportAttributeKeyMapKey = @"mappedKeyName";
NSString *const kMagicalRecordImportAttributeValueClassNameKey = @"attributeValueClassName";

NSString *const kMagicalRecordImportRelationshipMapKey = @"mappedKeyName";
NSString *const kMagicalRecordImportRelationshipLinkedByKey = @"relatedByAttribute";
NSString *const kMagicalRecordImportDistinctAttributeKey = @"distinctAttribute";
NSString *const kMagicalRecordImportRelationshipTypeKey = @"type"; //this needs to be revisited
NSString *const kMagicalRecordImportExcludeFromImportKey = @"excludeFromImport";

NSString *const kMagicalRecordImportAttributeUseDefaultValueWhenNotPresent = @"useDefaultValueWhenNotPresent";

@implementation NSManagedObject (MagicalRecordDataImport)

#pragma mark - Callbacks

- (BOOL)MR_importValue:(id)value forKey:(NSString *)key
{
    NSString *selectorString = [NSString stringWithFormat:@"import%@:", [key MR_capitalizedFirstCharacterString]];
    SEL selector = NSSelectorFromString(selectorString);

    if ([self respondsToSelector:selector])
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation setArgument:&value atIndex:2];
        [invocation invoke];

        BOOL returnValue = YES;
        [invocation getReturnValue:&returnValue];
        return returnValue;
    }

    return NO;
}

- (BOOL)MR_shouldImportData:(id)relatedObjectData forRelationshipNamed:(NSString *)relationshipName
{
    BOOL shouldImport = YES; // By default, we always import
    SEL shouldImportSelector = NSSelectorFromString([NSString stringWithFormat:@"shouldImport%@:", [relationshipName MR_capitalizedFirstCharacterString]]);
    BOOL implementsShouldImport = [self respondsToSelector:shouldImportSelector];

    if (implementsShouldImport)
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:shouldImportSelector]];
        [invocation setSelector:shouldImportSelector];
        [invocation setArgument:&relatedObjectData atIndex:2];
        [invocation invokeWithTarget:self];

        [invocation getReturnValue:&shouldImport];
    }
    return shouldImport;
}

#pragma mark - Setting Attributes and Relationships

- (void)MR_setObject:(NSManagedObject *)relatedObject forRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSAssert2(relatedObject != nil, @"Cannot add nil to %@ for attribute %@", NSStringFromClass([self class]), [relationshipInfo name]);
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity] ?: [[NSEntityDescription alloc] init];
    NSAssert1([[destinationEntity name] length], @"entity on relationship %@ is not valid", [relationshipInfo name]);
    NSAssert2([[relatedObject entity] isKindOfEntity:destinationEntity], @"related object entity %@ not similar to destination entity %@", [relatedObject entity], [relationshipInfo destinationEntity]);
    
    //add related object to set
    NSString *addRelationMessageFormat = @"set%@:";
    id relationshipSource = self;
    if ([relationshipInfo isToMany])
    {
        addRelationMessageFormat = @"add%@Object:";
        if ([relationshipInfo respondsToSelector:@selector(isOrdered)] && [relationshipInfo isOrdered])
        {
            //Need to get the ordered set
            NSString *selectorName = [[relationshipInfo name] stringByAppendingString:@"Set"];
            SEL selector = NSSelectorFromString(selectorName);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation invokeWithTarget:self];
            
            __unsafe_unretained id orderedSet;
            [invocation getReturnValue:&orderedSet];
            relationshipSource = orderedSet;

            addRelationMessageFormat = @"addObject:";
        }
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wformat-nonliteral"
    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, MRAttributeNameFromString([relationshipInfo name])];
#pragma clang diagnostic pop

    SEL selector = NSSelectorFromString(addRelatedObjectToSetMessage);

    @try
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[relationshipSource methodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setArgument:&relatedObject atIndex:2];
        [invocation invokeWithTarget:relationshipSource];
    }
    @catch (NSException *exception)
    {
        MRLogError(@"Adding object for relationship failed: %@\n", relationshipInfo);
        MRLogError(@"relatedObject.entity %@", [relatedObject entity]);
        MRLogError(@"relationshipInfo.destinationEntity %@", [relationshipInfo destinationEntity]);
        MRLogError(@"Add Relationship Selector: %@", addRelatedObjectToSetMessage);
        MRLogError(@"perform selector error: %@", exception);
    }
}
- (void)MR_setAttribute:(NSAttributeDescription *)attributeInfo withValueFromObject:(id)objectData
{
    BOOL shouldExcludeFromImport = [[[attributeInfo userInfo] objectForKey:kMagicalRecordImportExcludeFromImportKey] isEqualToString:@"YES"];
    if (shouldExcludeFromImport)
    {
        return;
    }

    NSString *lookupKeyPath = [objectData MR_lookupKeyForProperty:attributeInfo];

    if (lookupKeyPath)
    {
        NSString *attributeName = [attributeInfo name];

        id value = [attributeInfo MR_valueForKeyPath:lookupKeyPath fromObjectData:objectData];
        if (value == nil && [attributeInfo MR_shouldUseDefaultValueIfNoValuePresent])
        {
            value = [attributeInfo defaultValue];
        }

        //        id value = [attributeInfo MR_valueForKeyPath:lookupKeyPath fromObjectData:objectData];
        if (value && ![self MR_importValue:value forKey:attributeName])
        {
            [self setValue:value forKey:attributeName];
        }
    }
    //    else if ([attributeInfo MR_shouldUseDefaultValueIfNoValuePresent])
    //    {
    //        id value = [attributeInfo defaultValue];
    //        if (![self MR_importValue:value forKey:attributeName])
    //        {
    //            [self setValue:value forKey:attributeName];
    //        }
    //    }
}

- (void)MR_setRelationship:(NSRelationshipDescription *)relationshipInfo relatedData:(id)relationshipData setRelationshipBlock:(void (^)(NSRelationshipDescription *, id))setRelationshipBlock
{
    NSString *relationshipName = [relationshipInfo name];

    if ([self MR_importValue:relationshipData forKey:relationshipName])
        return; //If custom import was used

    NSString *lookupKey = [[relationshipInfo userInfo] objectForKey:kMagicalRecordImportRelationshipMapKey] ?: relationshipName;
    id relatedObjectData = [relationshipData valueForKeyPath:lookupKey];
    if (relatedObjectData == nil)
    {
        lookupKey = [relationshipData MR_lookupKeyForProperty:relationshipInfo];
        @try
        {
            relatedObjectData = [relationshipData valueForKeyPath:lookupKey];
        }
        @catch (NSException *exception)
        {
            MRLogWarn(@"Looking up a key for relationship failed while importing: %@\n", relationshipInfo);
            MRLogWarn(@"lookupKey: %@", lookupKey);
            MRLogWarn(@"relationshipInfo.destinationEntity %@", relationshipInfo.destinationEntity);
            MRLogWarn(@"relationshipData: %@", relationshipData);
            MRLogWarn(@"Exception:\n%@: %@", exception.name, exception.reason);
        }
    }
    if (relatedObjectData == nil || [relatedObjectData isEqual:[NSNull null]])
        return;

    void (^establishRelationship)(NSRelationshipDescription *, id) = ^(NSRelationshipDescription *blockInfo, id blockData) {
        if ([self MR_shouldImportData:relatedObjectData forRelationshipNamed:relationshipName])
        {
            setRelationshipBlock(blockInfo, blockData);
        }
    };

    if ([relationshipInfo isToMany] && [relatedObjectData isKindOfClass:[NSArray class]])
    {
        for (id singleRelatedObjectData in relatedObjectData)
        {
            establishRelationship(relationshipInfo, singleRelatedObjectData);
        }
    }
    else
    {
        establishRelationship(relationshipInfo, relatedObjectData);
    }
}

#pragma mark - Attribute and Relationship traversal

- (void)MR_setAttributes:(NSDictionary *)attributes forKeysWithObject:(id)objectData
{
    for (NSString *attributeName in attributes)
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];

        [self MR_setAttribute:attributeInfo withValueFromObject:objectData];
    }
}

- (void)MR_setRelationships:(NSDictionary *)relationshipDescriptions forKeysWithObject:(id)relationshipData withBlock:(void (^)(NSRelationshipDescription *, id))setRelationshipBlock
{
    [relationshipDescriptions enumerateKeysAndObjectsUsingBlock:^(__unused id relationshipName, id relationshipDescription, __unused  BOOL *stop) {
        [self MR_setRelationship:relationshipDescription
                     relatedData:relationshipData
            setRelationshipBlock:setRelationshipBlock];
    }];
}

#pragma mark - Pre/Post Import Events

- (BOOL)MR_preImport:(id)objectData
{
    if ([self respondsToSelector:@selector(shouldImport:)])
    {
        BOOL shouldImport = (BOOL)[self shouldImport:objectData];
        if (!shouldImport)
        {
            return NO;
        }
    }

    if ([self respondsToSelector:@selector(willImport:)])
    {
        [self willImport:objectData];
    }

    return YES;
}

- (BOOL)MR_postImport:(id)objectData
{
    if ([self respondsToSelector:@selector(didImport:)])
    {
        [self performSelector:@selector(didImport:) withObject:objectData];
    }

    return YES;
}

#pragma mark - Lookup related/existing data and objects

- (NSManagedObject *)MR_lookupObjectForRelationship:(NSRelationshipDescription *)relationshipInfo fromData:(id)singleRelatedObjectData
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    NSManagedObject *objectForRelationship = nil;

    id relatedValue;

    // if its a primitive class, than handle singleRelatedObjectData as the key for relationship
    if ([singleRelatedObjectData isKindOfClass:[NSString class]] ||
        [singleRelatedObjectData isKindOfClass:[NSNumber class]])
    {
        relatedValue = singleRelatedObjectData;
    }
    else if ([singleRelatedObjectData isKindOfClass:[NSDictionary class]])
    {
        relatedValue = [singleRelatedObjectData MR_relatedValueForRelationship:relationshipInfo];
    }
    else
    {
        relatedValue = singleRelatedObjectData;
    }

    if (relatedValue)
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        Class managedObjectClass = NSClassFromString([destinationEntity managedObjectClassName]);
				NSString *relatedByAtribute = [relationshipInfo.userInfo objectForKey:kMagicalRecordImportRelationshipLinkedByKey];

				if (relatedByAtribute == nil || [relatedByAtribute length] == 0) {
            relatedByAtribute = [[destinationEntity MR_primaryAttribute] name];
        }       
				
        if ([relatedByAtribute length])
        {
            objectForRelationship = [managedObjectClass MR_findFirstByAttribute:relatedByAtribute
                                                                      withValue:relatedValue
                                                                      inContext:context];
        }
    }

    return objectForRelationship;
}

#pragma mark - Kicking off importing

- (BOOL)MR_importValuesForKeysWithObject:(id)objectData establishRelationshipBlock:(void (^)(NSRelationshipDescription *, id))relationshipBlock
{
    BOOL didStartimporting = [self MR_preImport:objectData];
    if (!didStartimporting)
        return NO;

    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithObject:objectData];

    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships forKeysWithObject:objectData withBlock:relationshipBlock];

    return [self MR_postImport:objectData];
}

- (BOOL)MR_importValuesForKeysWithObject:(id)objectData
{
    __weak typeof(self) weakSelf = self;

    void (^esablishRelationship)(NSRelationshipDescription *, id) = ^(NSRelationshipDescription *relationshipInfo, id localObjectData) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        //Look up any existing objects
        NSManagedObject *relatedObject = [strongSelf MR_lookupObjectForRelationship:relationshipInfo fromData:localObjectData];

        if (relatedObject == nil)
        {
            //create if none exist
            NSEntityDescription *entityDescription = [relationshipInfo destinationEntity];
            relatedObject = [entityDescription MR_createInstanceInContext:[strongSelf managedObjectContext]];
        }
        //import or update
        [relatedObject MR_importValuesForKeysWithObject:localObjectData];

        [strongSelf MR_setObject:relatedObject forRelationship:relationshipInfo];
    };

    return [self MR_importValuesForKeysWithObject:objectData establishRelationshipBlock:esablishRelationship];
}

#pragma mark - Class level importing

+ (id)MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context
{
    NSAttributeDescription *primaryAttribute = [[self MR_entityDescriptionInContext:context] MR_primaryAttribute];

    id value = [objectData MR_valueForAttribute:primaryAttribute];

    NSManagedObject *managedObject = nil;

    if (primaryAttribute != nil)
    {
        managedObject = [self MR_findFirstByAttribute:[primaryAttribute name] withValue:value inContext:context];
    }

    if (managedObject == nil)
    {
        managedObject = [self MR_createEntityInContext:context];
    }

    [managedObject MR_importValuesForKeysWithObject:objectData];

    return managedObject;
}

+ (id)MR_importFromObject:(id)objectData
{
    return [self MR_importFromObject:objectData inContext:[[MagicalRecordStack defaultStack] context]];
}

#pragma mark - Import from collections

+ (NSArray *)MR_importFromArray:(id<NSFastEnumeration>)listOfObjectData
{
    return [self MR_importFromArray:listOfObjectData inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *)MR_importFromArray:(id<NSFastEnumeration>)listOfObjectData inContext:(NSManagedObjectContext *)context
{
    // See https://gist.github.com/4501089 and https://alpha.app.net/tonymillion/post/2397422

    NSMutableArray *objects = [NSMutableArray array];

    for (id obj in listOfObjectData)
    {
        NSManagedObject *importedObject = [self MR_importFromObject:obj inContext:context];
        [objects addObject:importedObject];
    }

    return objects;
}

@end
