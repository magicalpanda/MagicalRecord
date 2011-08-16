//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"

NSString * const kMagicalRecordImportDefaultDateFormatString = @"YYYY-MM-dd'T'HH:mm:ss'Z'";
NSString * const kMagicalRecordImportAttributeKeyMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportAttributeValueClassNameKey = @"attributeValueClassName";

NSString * const kMagicalRecordImportRelationshipMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportRelationshipPrimaryKey = @"primaryRelationshipKey";
NSString * const kMagicalRecordImportRelationshipTypeKey = @"type";


@implementation NSManagedObject (NSManagedObject_DataImport)

//- (NSCache *) MR_requestCache
//{
//    static dispatch_once_t pred;
//    static NSCache *mr_requestCache = nil;
//    
//    dispatch_once(&pred, ^{
//        mr_requestCache = [[NSCache alloc] init];
//        mr_requestCache.name = @"com.magicalpanda.magicalrecord.requestcache";
//        mr_requestCache.totalCostLimit = 100;
//    });
//    return mr_requestCache;
//}

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

- (void) MR_setAttributes:(NSDictionary *)attributes forKeysWithDictionary:(NSDictionary *)objectData
{    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        id value = [self MR_attributeValueFromDictionary:objectData forAttribute:attributeInfo];
        [self setValue:value forKey:attributeName];
    }
}

- (NSManagedObject *) MR_createInstanceForEntity:(NSEntityDescription *)entityDescription withDictionary:(id)objectData
{
    NSManagedObject *relatedObject = [NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] 
                                                                   inManagedObjectContext:[self managedObjectContext]];
    
    [relatedObject MR_setValuesForKeysWithJSONDictionary:objectData];
    
    return relatedObject;
}

- (NSManagedObject *) MR_findObjectForRelationship:(NSRelationshipDescription *)relationshipInfo withData:(id)singleRelatedObjectData
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    if (destinationEntity == nil) 
    {
        ARLog(@"Unable to find entity for type '%@'", [singleRelatedObjectData valueForKey:kMagicalRecordImportRelationshipTypeKey]);
        return nil;
    }

    NSString *primaryKeyName = [[relationshipInfo userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey] ?: 
                                    [NSString stringWithFormat:@"%@ID", primaryKeyNameFromString([destinationEntity name])];
    
    NSAttributeDescription *primaryKeyAttribute = [[destinationEntity attributesByName] valueForKey:primaryKeyName];
    NSString *lookupKey = [[primaryKeyAttribute userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: [primaryKeyAttribute name];
    
    NSManagedObject *objectForRelationship = nil;
    if (lookupKey) 
    {
        id lookupValue = [singleRelatedObjectData valueForKey:lookupKey];
        
        if (lookupValue) 
        {
            NSManagedObjectContext *context = [self managedObjectContext];
            Class managedObjectClass = NSClassFromString([destinationEntity managedObjectClassName]);
            objectForRelationship = [managedObjectClass findFirstByAttribute:primaryKeyName withValue:lookupValue inContext:context];
        }
    }

    return objectForRelationship;
}

- (void) MR_addObject:(NSManagedObject *)relatedObject forRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSAssert2(relatedObject != nil, @"Cannot add nil to %@ for attribute %@", NSStringFromClass([self class]), [relationshipInfo name]);    
    NSAssert2([relatedObject entity] == [relationshipInfo destinationEntity], @"related object entity %@ not same as destination entity %@", [relatedObject entity], [relationshipInfo destinationEntity]);

    //add related object to set
    NSString *addRelationMessageFormat = [relationshipInfo isToMany] ? @"add%@Object:" : @"set%@:";
    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, attributeNameFromString([relationshipInfo name])];
 
    SEL selector = NSSelectorFromString(addRelatedObjectToSetMessage);
    
    @try 
    {
        [self performSelector:selector withObject:relatedObject];        
    }
    @catch (NSException *exception) 
    {
        ARLog(@"Adding object for relationship failed: %@\n", relationshipInfo);
        ARLog(@"relatedObject.entity %@", [relatedObject entity]);
        ARLog(@"relationshipInfo.destinationEntity %@", [relationshipInfo destinationEntity]);
        
        ARLog(@"perform selector error: %@", exception);
    }
}

- (void) MR_setRelationships:(NSDictionary *)relationships forKeysWithDictionary:(NSDictionary *)relationshipData withBlock:(void(^)(NSRelationshipDescription *,NSDictionary *))setRelationshipBlock
{
    for (NSString *relationshipName in relationships) 
    {
        NSRelationshipDescription *relationshipInfo = [relationships valueForKey:relationshipName];
        
        NSString *lookupKey = [[relationshipInfo userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey] ?: relationshipName;
        
        id relatedObjectData = [relationshipData valueForKey:lookupKey];
        
        if (relatedObjectData == nil || [relatedObjectData isEqual:[NSNull null]]) 
        {
            continue;
        }

        if ([relationshipInfo isToMany]) 
        {
            for (id singleRelatedObjectData in relatedObjectData) 
            {
                setRelationshipBlock(relationshipInfo, singleRelatedObjectData);
            }
        }
        else
        {
            setRelationshipBlock(relationshipInfo, relatedObjectData);
        }
    }
}

- (void) MR_setRelationships:(NSDictionary *)relationships forKeysWithDictionary:(NSDictionary *)relationshipData
{
    [self MR_setRelationships:relationships
        forKeysWithDictionary:relationshipData 
                    withBlock:^(NSRelationshipDescription *relationshipInfo, NSDictionary *objectData)
     {
         NSManagedObject *relatedObject = [self MR_findObjectForRelationship:relationshipInfo
                                                                    withData:objectData];
         if (relatedObject == nil)
         {
             relatedObject = [self MR_createInstanceForEntity:[relationshipInfo destinationEntity]
                                               withDictionary:objectData];
         }
         else
         {
             [relatedObject MR_setValuesForKeysWithJSONDictionary:objectData];
         }
         
         [self MR_addObject:relatedObject forRelationship:relationshipInfo];            
     }];
}

- (void) MR_setValuesForKeysWithJSONDictionary:(NSDictionary *)objectData
{
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships forKeysWithDictionary:objectData];
}

+ (id) MR_importFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context;
{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:[[self entityDescription] name] 
                                                                   inManagedObjectContext:context];
    [managedObject MR_setValuesForKeysWithJSONDictionary:objectData];
    return managedObject;
}

+ (id) MR_importFromDictionary:(NSDictionary *)objectData
{
    return [self MR_importFromDictionary:objectData inContext:[NSManagedObjectContext defaultContext]];
}

+ (id) MR_updateFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context
{
    //find object
    //create if not exists
    //apply dictionary updates
    return nil;
}

+ (id) MR_updateFromDictionary:(NSDictionary *)objectData
{
    return [self MR_updateFromDictionary:objectData inContext:[NSManagedObjectContext defaultContext]];    
}

@end
