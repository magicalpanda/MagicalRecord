//
//  NSManagedObject+MagicalDataImport.m
//
//  Created by Saul Mora on 6/28/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordStack.h"
#import "CoreData+MagicalRecord.h"
#import "NSObject+MagicalDataImport.h"
#import "MagicalRecordLogging.h"
#import <objc/runtime.h>

void MR_swapMethodsFromClass(Class c, SEL orig, SEL new);

NSString * const kMagicalRecordImportCustomDateFormatKey            = @"dateFormat";
NSString * const kMagicalRecordImportDefaultDateFormatString        = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
NSString * const kMagicalRecordImportUnixDate13String               = @"unixTime13";

NSString * const kMagicalRecordImportAttributeKeyMapKey             = @"mappedKeyName";
NSString * const kMagicalRecordImportAttributeValueClassNameKey     = @"attributeValueClassName";

NSString * const kMagicalRecordImportRelationshipMapKey             = @"mappedKeyName";
NSString * const kMagicalRecordImportRelationshipLinkedByKey        = @"relatedByAttribute";
NSString * const kMagicalRecordImportRelationshipTypeKey            = @"type";  //this needs to be revisited

NSString * const kMagicalRecordImportAttributeUseDefaultValueWhenNotPresent = @"useDefaultValueWhenNotPresent";

@interface NSObject (MagicalRecord_DataImportControls)

- (id) MR_valueForUndefinedKey:(NSString *)key;

@end


@interface NSObject (MagicalRecord_DataImportInternal)

- (id) MR_valueForUndefinedKey:(NSString *)key;

@end

@implementation NSManagedObject (MagicalRecord_DataImport)

- (BOOL) MR_importValue:(id)value forKey:(NSString *)key
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
        return YES;
    }
    return NO;
}

- (void) MR_setAttributes:(NSDictionary *)attributes forKeysWithObject:(id)objectData
{    
    for (NSString *attributeName in attributes) 
    {
        NSAttributeDescription *attributeInfo = [attributes valueForKey:attributeName];
        NSString *lookupKeyPath = [objectData MR_lookupKeyForAttribute:attributeInfo];
        
        if (lookupKeyPath) 
        {
            id value = [attributeInfo MR_valueForKeyPath:lookupKeyPath fromObjectData:objectData];
            if (![self MR_importValue:value forKey:attributeName])
            {
                [self setValue:value forKey:attributeName];
            }
        } 
        else 
        {
            if ([[[attributeInfo userInfo] objectForKey:kMagicalRecordImportAttributeUseDefaultValueWhenNotPresent] boolValue]) 
            {
                id value = [attributeInfo defaultValue];
                if (![self MR_importValue:value forKey:attributeName])
                {
                    [self setValue:value forKey:attributeName];
                }
            }
        }
    }
}

- (NSManagedObject *) MR_findObjectForRelationship:(NSRelationshipDescription *)relationshipInfo withData:(id)singleRelatedObjectData
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
        NSString *primaryKey = [relationshipInfo MR_primaryKey];
        objectForRelationship = [managedObjectClass MR_findFirstByAttribute:primaryKey
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
        if ([relationshipInfo respondsToSelector:@selector(isOrdered)] && [relationshipInfo isOrdered])
        {
            //Need to get the ordered set
            NSString *selectorName = [[relationshipInfo name] stringByAppendingString:@"Set"];
            SEL selector = NSSelectorFromString(selectorName);
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation invokeWithTarget:self];
            [invocation getReturnValue:&relationshipSource];

            addRelationMessageFormat = @"addObject:";
        }
    }

    NSString *addRelatedObjectToSetMessage = [NSString stringWithFormat:addRelationMessageFormat, MR_attributeNameFromString([relationshipInfo name])];
 
    SEL selector = NSSelectorFromString(addRelatedObjectToSetMessage);
    
    @try 
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
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

- (BOOL) MR_shouldImportData:(id)relatedObjectData forRelationshipNamed:(NSString *)relationshipName;
{
    BOOL shouldImport = YES; // By default, we always import
    SEL shouldImportSelector = NSSelectorFromString([NSString stringWithFormat:@"shouldImport%@:", [relationshipName MR_capitalizedFirstCharacterString]]);
    BOOL implementsShouldImport = (BOOL)[self respondsToSelector:shouldImportSelector];

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

- (void) MR_setRelationships:(NSDictionary *)relationships forKeysWithObject:(id)relationshipData withBlock:(void(^)(NSRelationshipDescription *,id))setRelationshipBlock
{
    for (NSString *relationshipName in relationships) 
    {
        if ([self MR_importValue:relationshipData forKey:relationshipName]) 
        {
            continue;
        }
        
        NSRelationshipDescription *relationshipInfo = [relationships valueForKey:relationshipName];
        
        NSString *lookupKey = [[relationshipInfo userInfo] valueForKey:kMagicalRecordImportRelationshipMapKey] ?: relationshipName;
        id relatedObjectData = [relationshipData valueForKeyPath:lookupKey];
        
        if (relatedObjectData == nil || [relatedObjectData isEqual:[NSNull null]]) 
        {
            continue;
        }

        void (^establishRelationship)(NSRelationshipDescription *, id) = ^(NSRelationshipDescription *blockInfo, id blockData)
        {
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
}

- (BOOL) MR_preImport:(id)objectData;
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
    MR_swapMethodsFromClass([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    return YES;
}

- (BOOL) MR_postImport:(id)objectData;
{
    MR_swapMethodsFromClass([objectData class], @selector(valueForUndefinedKey:), @selector(MR_valueForUndefinedKey:));
    if ([self respondsToSelector:@selector(didImport:)])
    {
        [self performSelector:@selector(didImport:) withObject:objectData];
    }
    return YES;
}

- (BOOL) MR_performDataImportFromObject:(id)objectData relationshipBlock:(void(^)(NSRelationshipDescription*, id))relationshipBlock;
{
    BOOL didStartimporting = [self MR_preImport:objectData];
    if (!didStartimporting) return NO;
    
    NSDictionary *attributes = [[self entity] attributesByName];
    [self MR_setAttributes:attributes forKeysWithObject:objectData];
    
    NSDictionary *relationships = [[self entity] relationshipsByName];
    [self MR_setRelationships:relationships forKeysWithObject:objectData withBlock:relationshipBlock];
    
    return [self MR_postImport:objectData];  
}

- (BOOL) MR_importValuesForKeysWithObject:(id)objectData
{
	__weak typeof(self) weakself = self;
    return [self MR_performDataImportFromObject:objectData
                              relationshipBlock:^(NSRelationshipDescription *relationshipInfo, id localObjectData) {
        
        NSManagedObject *relatedObject = [weakself MR_findObjectForRelationship:relationshipInfo withData:localObjectData];
        
        if (relatedObject == nil)
        {
            NSEntityDescription *entityDescription = [relationshipInfo destinationEntity];
            relatedObject = [entityDescription MR_createInstanceInContext:[weakself managedObjectContext]];
        }
        [relatedObject MR_importValuesForKeysWithObject:localObjectData];
        
        if ((localObjectData) && (![localObjectData isKindOfClass:[NSDictionary class]]))
        {
			NSString * relatedByAttribute = [[relationshipInfo userInfo] objectForKey:kMagicalRecordImportRelationshipLinkedByKey] ?: MR_primaryKeyNameFromString([[relationshipInfo destinationEntity] name]);
			
            if (relatedByAttribute)
            {
                if (![relatedObject MR_importValue:localObjectData forKey:relatedByAttribute])
                {
                    [relatedObject setValue:localObjectData forKey:relatedByAttribute];
                }
            }
        }
        
        [weakself MR_addObject:relatedObject forRelationship:relationshipInfo];
	}];
}

+ (id) MR_importFromObject:(id)objectData inContext:(NSManagedObjectContext *)context;
{
    NSAttributeDescription *primaryAttribute = [[self MR_entityDescriptionInContext:context] MR_primaryAttributeToRelateBy]; // TODO: Call out this bug
    
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

+ (id) MR_importFromObject:(id)objectData
{
    return [self MR_importFromObject:objectData inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData
{
    return [self MR_importFromArray:listOfObjectData inContext:[[MagicalRecordStack defaultStack] context]];
}

+ (NSArray *) MR_importFromArray:(NSArray *)listOfObjectData inContext:(NSManagedObjectContext *)context
{
    // See https://gist.github.com/4501089 and https://alpha.app.net/tonymillion/post/2397422
    
    NSMutableArray *objects = [NSMutableArray array];

    [listOfObjectData enumerateObjectsWithOptions:0
                                       usingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSDictionary* dict = obj;
         
         if([dict isKindOfClass:[NSDictionary class]])
         {
             NSManagedObject *importedObject = [self MR_importFromObject:dict
                                                               inContext:context];
             [objects addObject:importedObject];
         }
     }];
    
    return objects;
}

@end


void MR_swapMethodsFromClass(Class c, SEL orig, SEL new)
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
