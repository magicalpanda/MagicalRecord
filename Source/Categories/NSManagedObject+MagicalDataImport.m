//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"

NSString * const kMagicalRecordImportCustomDateFormatKey = @"dateFormat";
NSString * const kMagicalRecordImportDefaultDateFormatString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const kMagicalRecordImportAttributeKeyMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportAttributeValueClassNameKey = @"attributeValueClassName";

NSString * const kMagicalRecordImportRelationshipMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportRelationshipPrimaryKey = @"primaryRelationshipKey";
NSString * const kMagicalRecordImportRelationshipTypeKey = @"type";



@implementation NSManagedObject (MagicalRecord_DataImport)

- (id) MR_valueForAttribute:(NSAttributeDescription *)attributeInfo fromObjectData:(NSDictionary *)objectData forKeyPath:(NSString *)keyPath
{
    id value = [objectData valueForKeyPath:keyPath];
    
    NSAttributeType attributeType = [attributeInfo attributeType];
    NSString *desiredAttributeType = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportAttributeValueClassNameKey];
    if (desiredAttributeType) 
    {
        if ([desiredAttributeType hasSuffix:@"Color"])
        {
            value = colorFromString(value);
        }
    }
    else 
    {
        if (attributeType == NSDateAttributeType)
        {
            if (![value isKindOfClass:[NSDate class]]) 
            {
                NSString *dateFormat = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportCustomDateFormatKey];
                value = dateFromString([value description], dateFormat ?: kMagicalRecordImportDefaultDateFormatString);
            }
            value = adjustDateForDST(value);
        }
    }
    
    return value == [NSNull null] ? nil : value;
}

- (void) MR_setAttributes:(NSDictionary *)attributes forKeysWithDictionary:(NSDictionary *)objectData
{    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        NSString *lookupKeyPath = [objectData MR_lookupKeyForAttribute:attributeInfo];
        
        if (lookupKeyPath) 
        {
            id value = [self MR_valueForAttribute:attributeInfo fromObjectData:objectData forKeyPath:lookupKeyPath];
            [self setValue:value forKey:attributeName];
        }
    }
}

- (NSManagedObject *) MR_createInstanceForEntity:(NSEntityDescription *)entityDescription withDictionary:(id)objectData
{
    NSManagedObject *relatedObject = [NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] 
                                                                   inManagedObjectContext:[self managedObjectContext]];
    
    [relatedObject MR_importValuesForKeysWithDictionary:objectData];
    
    return relatedObject;
}

- (NSManagedObject *) MR_findObjectForRelationship:(NSRelationshipDescription *)relationshipInfo withData:(id)singleRelatedObjectData
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    NSManagedObject *objectForRelationship = nil;
    id relatedValue = [singleRelatedObjectData MR_relatedValueForRelationship:relationshipInfo];

    if (relatedValue) 
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        Class managedObjectClass = NSClassFromString([destinationEntity managedObjectClassName]);
        objectForRelationship = [managedObjectClass findFirstByAttribute:[relationshipInfo MR_primaryKey]
                                                               withValue:relatedValue
                                                               inContext:context];
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

- (void) MR_setRelationships:(NSDictionary *)relationships forKeysWithDictionary:(NSDictionary *)relationshipData withBlock:(void(^)(NSRelationshipDescription *,id))setRelationshipBlock
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

- (void) MR_importValuesForKeysWithDictionary:(NSDictionary *)objectData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships
        forKeysWithDictionary:objectData 
                    withBlock:^(NSRelationshipDescription *relationshipInfo, id objectData)
     {
         NSManagedObject *relatedObject = nil;
         if ([objectData isKindOfClass:[NSDictionary class]]) 
         {
             relatedObject = [self MR_createInstanceForEntity:[relationshipInfo destinationEntity] withDictionary:objectData];
         }
         else
         {
             relatedObject = [self MR_findObjectForRelationship:relationshipInfo withData:objectData];
         }
         [relatedObject MR_importValuesForKeysWithDictionary:objectData];

         [self MR_addObject:relatedObject forRelationship:relationshipInfo];            
     }];
    
    [pool drain];
}

- (void) MR_updateValuesForKeysWithDictionary:(NSDictionary *)objectData
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships
        forKeysWithDictionary:objectData 
                    withBlock:^(NSRelationshipDescription *relationshipInfo, id objectData)
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
             [relatedObject MR_importValuesForKeysWithDictionary:objectData];
         }
         
         [self MR_addObject:relatedObject forRelationship:relationshipInfo];            
     }];
    
    [pool drain];
}

+ (id) MR_importFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context;
{
    NSManagedObject *managedObject = [self createInContext:context];
    [managedObject MR_importValuesForKeysWithDictionary:objectData];
    return managedObject;
}

+ (id) MR_importFromDictionary:(NSDictionary *)objectData
{
    return [self MR_importFromDictionary:objectData inContext:[NSManagedObjectContext defaultContext]];
}

+ (id) MR_updateFromDictionary:(NSDictionary *)objectData inContext:(NSManagedObjectContext *)context
{
    NSAttributeDescription *primaryAttribute = [[self entityDescription] MR_primaryKeyAttribute];
    
    id value = [objectData MR_valueForAttribute:primaryAttribute];
    
    NSManagedObject *manageObject = [self findFirstByAttribute:[primaryAttribute name] withValue:value inContext:context];
    if (!manageObject) 
    {
        manageObject = [self createInContext:context];
        [manageObject MR_importValuesForKeysWithDictionary:objectData];
    }
    else
    {
        [manageObject MR_updateValuesForKeysWithDictionary:objectData];
    }
    return manageObject;
}

+ (id) MR_updateFromDictionary:(NSDictionary *)objectData
{
    return [self MR_updateFromDictionary:objectData inContext:[NSManagedObjectContext defaultContext]];    
}

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData
{
    return [self MR_importFromArray:listOfObjectData inContext:[NSManagedObjectContext defaultContext]];
}

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *objectIDs = [NSMutableArray array];
    [MRCoreDataAction saveDataWithBlock:^(NSManagedObjectContext *localContext) 
     {    
         [listOfObjectData enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) 
          {
              NSDictionary *objectData = (NSDictionary *)obj;
              
              NSManagedObject *dataObject = [self MR_importFromDictionary:objectData inContext:localContext];
              
              if ([context obtainPermanentIDsForObjects:[NSArray arrayWithObject:dataObject] error:nil])
              {
                  [objectIDs addObject:[dataObject objectID]];
              }
          }];
     }];
    
    return [self findAllWithPredicate:[NSPredicate predicateWithFormat:@"self IN %@", objectIDs] inContext:context];
}

@end
