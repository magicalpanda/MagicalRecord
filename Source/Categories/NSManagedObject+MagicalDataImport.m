//
//  NSManagedObject+JSONHelpers.m
//  Gathering
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "NSManagedObject+MagicalDataImport.h"

static NSString * const kNSManagedObjectDefaultDateFormatString = @"YYYY-MM-dd'T'HH:mm:ss'Z'";
static NSString * const kNSManagedObjectAttributeJSONKeyMapKey = @"jsonKeyName";
static NSString * const kNSManagedObjectAttributeJSONValueClassNameKey = @"attributeValueClassName";

static NSString * const kNSManagedObjectRelationshipJSONMapKey = @"jsonKeyName";
static NSString * const kNSManagedObjectRelationshipJSONPrimaryKey = @"primaryRelationshipKey";
static NSString * const kNSManagedObjectRelationshipJSONTypeKey = @"type";


@implementation NSString (JSONParsingHelpers)

- (NSDate *) mr_dateFromJSONString;
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kNSManagedObjectDefaultDateFormatString];
    
    return [formatter dateFromString:self];
}

@end

@implementation NSManagedObject (NSManagedObject_JSONHelpers)

- (id) attributeValueFromJSONDicationary:(NSDictionary *)jsonData forAttribute:(NSAttributeDescription *)attributeInfo
{
    NSString *attributeName = [attributeInfo name];
    NSString *lookupKey = [[attributeInfo userInfo] valueForKey:kNSManagedObjectAttributeJSONKeyMapKey] ?: attributeName;
    id value = [jsonData valueForKey:lookupKey];
    
    if (value == nil || [value isEqual:[NSNull null]])
    {
        return nil;
    }
    
    NSAttributeType attributeType = [attributeInfo attributeType];
    if (attributeType == NSDateAttributeType)
    {
        value = [value mr_dateFromJSONString];
    }
    
    return value;
}

- (void) setAttributes:(NSDictionary *)attributes forKeysWithJSONDictionary:(NSDictionary *)jsonData
{    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        id value = [self attributeValueFromJSONDicationary:jsonData forAttribute:attributeInfo];
        [self setValue:value forKey:attributeName];
    }
}

- (NSManagedObject *) createInstanceForEntity:(NSEntityDescription *)entityDescription withJSONDictionary:(id)jsonData
{
    NSManagedObject *relatedObject = [[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[self managedObjectContext]];
    
    [relatedObject setValuesForKeysWithJSONDictionary:jsonData];
    
    return relatedObject;
}

- (NSManagedObject *)findObjectForRelationship:(NSRelationshipDescription *)relationshipInfo withJSONData:(id)singleRelatedObjectData
{
    NSEntityDescription *originalDestinationEntity = [relationshipInfo destinationEntity];
    NSDictionary *subentities = [originalDestinationEntity subentitiesByName];
    NSEntityDescription *destinationEntity = [subentities count] /* && ![entityDescription isAbstract]*/ ? 
                                                [subentities valueForKey:[singleRelatedObjectData valueForKey:kNSManagedObjectRelationshipJSONTypeKey]] :
                                                originalDestinationEntity;

    if (destinationEntity == nil) 
    {
        NSLog(@"Unable to find entity for type '%@'", [singleRelatedObjectData valueForKey:kNSManagedObjectRelationshipJSONTypeKey]);
        return nil;
    }
    
    Class managedObjectClass = NSClassFromString([destinationEntity managedObjectClassName]);
    NSAssert([managedObjectClass isSubclassOfClass:[NSManagedObject class]], @"Entity is not a managed object! Whoa!");
    
//    NSString *lookupKey = [[destinationEntity userInfo] valueForKey:kNSManagedObjectAttributeJSONKeyMapKey] ?: [destinationEntity name];
    
    id existingObject = nil; //[managedObjectClass findFirstByAttribute:@"" withValue:@"" inContext:[self managedObjectContext]];
    
    return existingObject ?: [self createInstanceForEntity:destinationEntity withJSONDictionary:singleRelatedObjectData];
}

- (void) addObject:(NSManagedObject *)relatedObject forRelationship:(NSRelationshipDescription *)relationshipInfo
{
    //add related object to set
    NSString *addRelationMessageFormat = [relationshipInfo isToMany] ? @"add%@Object:" : @"set%@:";
    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, [[relationshipInfo name] capitalizedString]];
    
    [self performSelector:NSSelectorFromString(addRelatedObjectToSetMessage) withObject:relatedObject];
}

- (void) setRelationships:(NSDictionary *)relationships forKeysWithJSONDictionary:(NSDictionary *)jsonData
{
    for (NSString *relationshipName in relationships) 
    {
        NSRelationshipDescription *relationshipInfo = [relationships valueForKey:relationshipName];
        
        NSString *lookupKey = [[relationshipInfo userInfo] valueForKey:kNSManagedObjectRelationshipJSONMapKey] ?: relationshipName;
        
        id relatedObjectData = [jsonData valueForKey:lookupKey];
        
        if (relatedObjectData == nil || [relatedObjectData isEqual:[NSNull null]]) 
        {
            continue;
        }
        
        if ([relationshipInfo isToMany]) 
        {
            for (id singleRelatedObjectData in relatedObjectData) 
            {
                NSManagedObject *relatedObject = [self findObjectForRelationship:relationshipInfo
                                                                    withJSONData:singleRelatedObjectData];
                
                [self addObject:relatedObject forRelationship:relationshipInfo];
            }
        }
        else
        {
            NSManagedObject *relatedObject = [self findObjectForRelationship:relationshipInfo
                                                                withJSONData:relatedObjectData];
            
            [self addObject:relatedObject forRelationship:relationshipInfo];
        }
    }
}

- (void) setValuesForKeysWithJSONDictionary:(NSDictionary *)jsonData
{
    NSDictionary *attributes = [[self entity] attributesByName];
    [self setAttributes:attributes forKeysWithJSONDictionary:jsonData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self setRelationships:relationships forKeysWithJSONDictionary:jsonData];
}

+ (NSManagedObject *) mr_importFromDictionary:(NSDictionary *)data;
{
    return nil;
}

@end
