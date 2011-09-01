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
NSUInteger const kMagicalRecordImportMaximumAttributeFailoverDepth = 10;

@implementation NSAttributeDescription (MagicalRecord_DataImport)

- (NSString *) MR_primaryKey;
{
    return nil;
}

@end
@implementation NSRelationshipDescription (MagicalRecord_DataImport)

- (NSString *) MR_primaryKey;
{
    NSString *primaryKeyName = [[self userInfo] valueForKey:kMagicalRecordImportRelationshipPrimaryKey] ?: 
    primaryKeyNameFromString([[self destinationEntity] name]);
    
    return primaryKeyName;
}

@end

@implementation NSDictionary (MagicalRecord_DataImport)

- (NSString *) MR_lookupKeyForAttribute:(NSAttributeDescription *)attributeInfo;
{
    NSString *attributeName = [attributeInfo name];
    NSString *lookupKey = [[attributeInfo userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: attributeName;
    
    id value = [self valueForKeyPath:lookupKey];
    
    for (int i = 1; i < kMagicalRecordImportMaximumAttributeFailoverDepth && value == nil; i++)
    {
        attributeName = [NSString stringWithFormat:@"%@.%d", kMagicalRecordImportAttributeKeyMapKey, i];
        lookupKey = [[attributeInfo userInfo] valueForKey:attributeName];
        if (lookupKey == nil) 
        {
            return nil;
        }
        value = [self valueForKeyPath:lookupKey];
    }

    return value != nil ? lookupKey : nil;
}

- (NSString *) MR_lookupKeyForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSEntityDescription *destinationEntity = [relationshipInfo destinationEntity];
    if (destinationEntity == nil) 
    {
        ARLog(@"Unable to find entity for type '%@'", [self valueForKey:kMagicalRecordImportRelationshipTypeKey]);
        return nil;
    }

    NSString *primaryKeyName = [relationshipInfo MR_primaryKey];
    
    NSAttributeDescription *primaryKeyAttribute = [[destinationEntity attributesByName] valueForKey:primaryKeyName];
    NSString *lookupKey = [[primaryKeyAttribute userInfo] valueForKey:kMagicalRecordImportAttributeKeyMapKey] ?: [primaryKeyAttribute name];

    return lookupKey;
}

- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    NSString *lookupKey = [self MR_lookupKeyForRelationship:relationshipInfo];
    return lookupKey ? [self valueForKeyPath:lookupKey] : nil;
}

@end

@implementation NSNumber (MagicalRecord_DataImport)

- (id) MR_relatedValueForRelationship:(NSRelationshipDescription *)relationshipInfo
{
    return self;
}

- (NSString *) MR_lookupKeyForAttribute:(NSAttributeDescription *)attributeInfo
{
    return nil;
}

@end


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
            value = ColorFromString(value);
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
    
    [relatedObject MR_setValuesForKeysWithJSONDictionary:objectData];
    
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

        if ([relationshipInfo isToMany] ) //|| [relatedObjectData isKindOfClass:[NSArray class]]) 
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
    NSManagedObject *managedObject = [self createInContext:context];
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

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData
{
    return [self MR_importFromArray:listOfObjectData inContext:[NSManagedObjectContext context]];
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
