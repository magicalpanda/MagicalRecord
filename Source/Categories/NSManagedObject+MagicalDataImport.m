//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

void swizzle(Class c, SEL orig, SEL new);

NSString * const kMagicalRecordImportCustomDateFormatKey = @"dateFormat";
NSString * const kMagicalRecordImportDefaultDateFormatString = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const kMagicalRecordImportAttributeKeyMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportAttributeValueClassNameKey = @"attributeValueClassName";

NSString * const kMagicalRecordImportRelationshipMapKey = @"mappedKeyName";
NSString * const kMagicalRecordImportRelationshipPrimaryKey = @"primaryRelationshipKey";
NSString * const kMagicalRecordImportRelationshipTypeKey = @"type";

@implementation NSString (MagicalRecord_DataImport)

- (NSString *) MR_capitalizedFirstCharaterString;
{
    NSString *firstChar = [[self substringToIndex:1] capitalizedString];
    return [firstChar stringByAppendingString:[self substringFromIndex:1]];
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

- (BOOL) MR_importValue:(id)value forKey:(NSString *)key
{
    NSString *selectorString = [NSString stringWithFormat:@"import%@:", [key MR_capitalizedFirstCharaterString]];
    SEL selector = NSSelectorFromString(selectorString);
    if ([self respondsToSelector:selector])
    {
        [self performSelector:selector withObject:value];
        return YES;
    }
    return NO;
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
            if (![self MR_importValue:value forKey:attributeName])
            {
                [self setValue:value forKey:attributeName];
            }
        }
    }
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
        objectForRelationship = [managedObjectClass MR_findFirstByAttribute:[relationshipInfo MR_primaryKey]
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
    NSString *addRelationMessageFormat = @"set%@:";
    id relationshipSource = self;
    if ([relationshipInfo isToMany]) 
    {
        addRelationMessageFormat = @"add%@Object:";
        if ([relationshipInfo isOrdered])
        {
            //Need to get the ordered set
            NSString *selectorName = [[relationshipInfo name] stringByAppendingString:@"Set"];
            relationshipSource = [self performSelector:NSSelectorFromString(selectorName)];
            addRelationMessageFormat = @"addObject:";
        }
    }

    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, attributeNameFromString([relationshipInfo name])];
 
    SEL selector = NSSelectorFromString(addRelatedObjectToSetMessage);
    
    @try 
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [relationshipSource performSelector:selector withObject:relatedObject];        
#pragma clang diagnostic pop
    }
    @catch (NSException *exception) 
    {
        MRLog(@"Adding object for relationship failed: %@\n", relationshipInfo);
        MRLog(@"relatedObject.entity %@", [relatedObject entity]);
        MRLog(@"relationshipInfo.destinationEntity %@", [relationshipInfo destinationEntity]);
        MRLog(@"Add Relationship Selector: %@", addRelatedObjectToSetMessage);   
        MRLog(@"perform selector error: %@", exception);
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
        
        SEL shouldImportSelector = @selector(shouldImport:);
        BOOL implementsShouldImport = [self respondsToSelector:shouldImportSelector];

        if (![self MR_importValue:relatedObjectData forKey:relationshipName])
        {
            if ([relationshipInfo isToMany])
            {
                for (id singleRelatedObjectData in relatedObjectData) 
                {
                    if (implementsShouldImport && !(BOOL)[self performSelector:shouldImportSelector withObject:singleRelatedObjectData]) 
                    {
                        continue;
                    }
                    setRelationshipBlock(relationshipInfo, singleRelatedObjectData);
                }
            }
            else
            {
                if (!(implementsShouldImport && !(BOOL)[self performSelector:shouldImportSelector withObject:relatedObjectData]))
                {
                    setRelationshipBlock(relationshipInfo, relatedObjectData);
                }
            }
        }
    }
}

- (void) MR_importValuesForKeysWithDictionary:(id)objectData
{
    swizzle([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    if ([self respondsToSelector:@selector(willImport)])
    {
        [self performSelector:@selector(willImport)];
    }
    
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships
        forKeysWithDictionary:objectData 
                    withBlock:^(NSRelationshipDescription *relationshipInfo, id objectData){

         NSManagedObject *relatedObject = nil;
         if ([objectData isKindOfClass:[NSDictionary class]]) 
         {
             relatedObject = [[relationshipInfo destinationEntity] MR_createInstanceFromDictionary:objectData inContext:[self managedObjectContext]];
         }
         else
         {
             relatedObject = [self MR_findObjectForRelationship:relationshipInfo withData:objectData];
         }
         [relatedObject MR_importValuesForKeysWithDictionary:objectData];

         [self MR_addObject:relatedObject forRelationship:relationshipInfo];            
    }];
    swizzle([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    
    if ([self respondsToSelector:@selector(didImport)])
    {
        [self performSelector:@selector(didImport)];
    }
}

- (void) MR_updateValuesForKeysWithDictionary:(id)objectData
{
    swizzle([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    if ([self respondsToSelector:@selector(willImport)])
    {
        [self performSelector:@selector(willImport)];
    }
    
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithDictionary:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships
        forKeysWithDictionary:objectData 
                    withBlock:^(NSRelationshipDescription *relationshipInfo, id objectData) {
                        
         NSManagedObject *relatedObject = [self MR_findObjectForRelationship:relationshipInfo
                                                                    withData:objectData];
         if (relatedObject == nil)
         {
             relatedObject = [[relationshipInfo destinationEntity] MR_createInstanceFromDictionary:objectData inContext:[self managedObjectContext]];
         }
         else
         {
             [relatedObject MR_importValuesForKeysWithDictionary:objectData];
         }
         
         [self MR_addObject:relatedObject forRelationship:relationshipInfo];            
    }];
    
    swizzle([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    
    if ([self respondsToSelector:@selector(didImport)])
    {
        [self performSelector:@selector(didImport)];
    }
}

+ (id) MR_importFromDictionary:(id)objectData inContext:(NSManagedObjectContext *)context;
{
    NSManagedObject *managedObject = [self MR_createInContext:context];
    [managedObject MR_importValuesForKeysWithDictionary:objectData];
    return managedObject;
}

+ (id) MR_importFromDictionary:(id)objectData
{
    return [self MR_importFromDictionary:objectData inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (id) MR_updateFromDictionary:(id)objectData inContext:(NSManagedObjectContext *)context
{
    NSAttributeDescription *primaryAttribute = [[self MR_entityDescription] MR_primaryKeyAttribute];
    
    id value = [objectData MR_valueForAttribute:primaryAttribute];
    
    NSManagedObject *managedObject = [self MR_findFirstByAttribute:[primaryAttribute name] withValue:value inContext:context];
    if (!managedObject) 
    {
        managedObject = [self MR_createInContext:context];
        [managedObject MR_importValuesForKeysWithDictionary:objectData];
    }
    else
    {
        [managedObject MR_updateValuesForKeysWithDictionary:objectData];
    }
    return managedObject;
}

+ (id) MR_updateFromDictionary:(id)objectData
{
    return [self MR_updateFromDictionary:objectData inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData
{
    return [self MR_importFromArray:listOfObjectData inContext:[NSManagedObjectContext MR_defaultContext]];
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
    
    return [self MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"self IN %@", objectIDs] inContext:context];
}

@end


void swizzle(Class c, SEL orig, SEL new)
{
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
    {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else
    {
        method_exchangeImplementations(origMethod, newMethod);
    }
}
