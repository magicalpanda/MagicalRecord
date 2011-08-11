//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"

NSString * const kMagicalRecordImportDefaultDateFormatString = @"YYYY-MM-dd'T'HH:mm:ss'Z'";
NSString * const kMagicalRecordImportAttributeKeyMapKey = @"jsonKeyName";
NSString * const kMagicalRecordImportAttributeValueClassNameKey = @"attributeValueClassName";

NSString * const kMagicalRecordImportRelationshipMapKey = @"jsonKeyName";
NSString * const kMagicalRecordImportRelationshipPrimaryKey = @"primaryRelationshipKey";
NSString * const kMagicalRecordImportRelationshipTypeKey = @"type";

@implementation NSManagedObject (NSManagedObject_DataImport)

- (id) MR_attributeValueFromDictionary:(NSDictionary *)jsonData forAttribute:(NSAttributeDescription *)attributeInfo
{
    NSString *attributeName = [attributeInfo name];
    NSString *lookupKey = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: attributeName;

    id value = [jsonData valueForKey:lookupKey];
    
    if (value == nil || [value isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSAttributeType attributeType = [attributeInfo attributeType];
    NSString *desiredAttributeType = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportAttributeValueClassNameKey];
    if (desiredAttributeType) 
    {
        if ([desiredAttributeType hasSuffix:@"Color"])
        {
            value = ColorFromString(value);
        }
    }
    else 
    {
        if (attributeType == NSDateAttributeType)
        {
            value = dateFromString([value description]);
        }
    }
    
    return value;
}

- (void) MR_setAttributes:(NSDictionary *)attributes forKeysWithDictionary:(NSDictionary *)jsonData
{    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        id value = [self MR_attributeValueFromDictionary:jsonData forAttribute:attributeInfo];
        [self setValue:value forKey:attributeName];
    }
}

- (NSManagedObject *) MR_createInstanceForEntity:(NSEntityDescription *)entityDescription withDictionary:(id)jsonData
{
    NSManagedObject *relatedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[self managedObjectContext]];
    
    [relatedObject MR_setValuesForKeysWithJSONDictionary:jsonData];
    
    return relatedObject;
}

- (NSManagedObject *) MR_findObjectForRelationship:(NSRelationshipDescription *)relationshipInfo withData:(id)singleRelatedObjectData
{
    NSEntityDescription *originalDestinationEntity = [relationshipInfo destinationEntity];
    NSDictionary *subentities = [originalDestinationEntity subentitiesByName];
    NSEntityDescription *destinationEntity = [subentities count] /* && ![entityDescription isAbstract]*/ ? 
                                                [subentities valueForKey:[singleRelatedObjectData valueForKey:kMagicalRecordImportRelationshipTypeKey]] :
                                                originalDestinationEntity;

    if (destinationEntity == nil) 
    {
        ARLog(@"Unable to find entity for type '%@'", [singleRelatedObjectData valueForKey:kMagicalRecordImportRelationshipTypeKey]);
        return nil;
    }
    
    NSAssert([NSClassFromString([destinationEntity managedObjectClassName]) isSubclassOfClass:[NSManagedObject class]], @"Entity is not a managed object! Whoa!");
    
//    NSString *lookupKey = [[destinationEntity userInfo] valueForKey:kNSManagedObjectAttributeJSONKeyMapKey] ?: [destinationEntity name];
    
    id existingObject = nil; //[managedObjectClass findFirstByAttribute:@"" withValue:@"" inContext:[self managedObjectContext]];
    
    return existingObject ?: [self MR_createInstanceForEntity:destinationEntity withDictionary:singleRelatedObjectData];
}

- (void) MR_addObject:(NSManagedObject *)relatedObject forRelationship:(NSRelationshipDescription *)relationshipInfo
{
    //add related object to set
    NSString *addRelationMessageFormat = [relationshipInfo isToMany] ? @"add%@Object:" : @"set%@:";
    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, attributeNameFromString([relationshipInfo name])];
    
    [self performSelector:NSSelectorFromString(addRelatedObjectToSetMessage) withObject:relatedObject];
}

- (void) MR_setRelationships:(NSDictionary *)relationships forKeysWithDictionary:(NSDictionary *)jsonData
{
    for (NSString *relationshipName in relationships) 
    {
        NSRelationshipDescription *relationshipInfo = [relationships valueForKey:relationshipName];
        
        NSString *lookupKey = [[relationshipInfo userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey] ?: relationshipName;
        
        id relatedObjectData = [jsonData valueForKey:lookupKey];
        
        if (relatedObjectData == nil || [relatedObjectData isEqual:[NSNull null]]) 
        {
            continue;
        }
        
        if ([relationshipInfo isToMany]) 
        {
            for (id singleRelatedObjectData in relatedObjectData) 
            {
                NSManagedObject *relatedObject = [self MR_findObjectForRelationship:relationshipInfo
                                                                    withData:singleRelatedObjectData];
                
                [self MR_addObject:relatedObject forRelationship:relationshipInfo];
            }
        }
        else
        {
            NSManagedObject *relatedObject = [self MR_findObjectForRelationship:relationshipInfo
                                                                withData:relatedObjectData];
            
            [self MR_addObject:relatedObject forRelationship:relationshipInfo];
        }
    }
}

- (void) MR_setValuesForKeysWithJSONDictionary:(NSDictionary *)jsonData
{
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:jsonData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships forKeysWithDictionary:jsonData];
}

+ (id) MR_importFromDictionary:(NSDictionary *)data inContext:(NSManagedObjectContext *)context;
{
    id managedObject = [[self alloc] initWithEntity:[self entityDescription] insertIntoManagedObjectContext:context];
    [managedObject MR_setValuesForKeysWithJSONDictionary:data];
    return managedObject;
}

+ (id) MR_importFromDictionary:(NSDictionary *)data
{
    return [self MR_importFromDictionary:data inContext:[NSManagedObjectContext defaultContext]];
}

@end
