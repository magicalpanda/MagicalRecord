//
//  KCCoreDataAccessorFix.m
//  KCOrderedAccessorFix
//
//  Created by Kevin Cassidy Jr. on 10/15/12.
//
//  This is free and unencumbered software released into the public domain.
//
//  Anyone is free to copy, modify, publish, use, compile, sell, or
//  distribute this software, either in source code form or as a compiled
//  binary, for any purpose, commercial or non-commercial, and by any
//  means.
//
//  In jurisdictions that recognize copyright laws, the author or authors
//  of this software dedicate any and all copyright interest in the
//  software to the public domain. We make this dedication for the benefit
//  of the public at large and to the detriment of our heirs and
//  successors. We intend this dedication to be an overt act of
//  relinquishment in perpetuity of all present and future rights to this
//  software under copyright law.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
//  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  For more information, please refer to <http://unlicense.org/>
//

#import "NSManagedObjectModel+KCOrderedAccessorFix.h"
#import <CoreData/CoreData.h>
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSManagedObjectModel (KCOrderedAccessorFix)

 - (void)kc_generateOrderedSetAccessors
{
    for (NSEntityDescription *entity in self) {
        [self kc_generateOrderedSetAccessorsForEntity:entity];
    }
}

- (void)kc_generateOrderedSetAccessorsForEntity:(NSEntityDescription *)entity
{
    [[entity relationshipsByName] enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSRelationshipDescription *relationship, BOOL *stop) {
        if ([relationship isToMany] && [relationship isOrdered])
        {
            [self kc_generateOrderedSetAccessorsForRelationship:relationship];
        }
    }];
}

- (void)kc_generateOrderedSetAccessorsForRelationship:(NSRelationshipDescription *)relationship
{
    Class entityClass = NSClassFromString([[relationship entity] managedObjectClassName]);
    
    NSString *relationshipName = [relationship name];
    
    NSString *capitalizedName = [relationshipName stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[relationshipName substringToIndex:1] uppercaseString]];
    
    const char *fastPrimitiveName = [[[NSString alloc] initWithFormat:@"primitive%@", capitalizedName] UTF8String];
    
    objc_property_t fastPrimitiveProp = class_getProperty(entityClass, fastPrimitiveName);
    if (fastPrimitiveProp == NULL)
    {
        objc_property_attribute_t type = {
            .name = "T",
            .value = "@\"NSMutableOrderedSet\"",
        };
        
        objc_property_attribute_t retain = {
            .name = "&",
            .value = "",
        };
        
        objc_property_attribute_t dynamic = {
            .name = "D",
            .value = "",
        };
        
        objc_property_attribute_t nonatomic = {
            .name = "N",
            .value = "",
        };
        
        objc_property_attribute_t propAttrs[] = {
            type,
            retain,
            dynamic,
            nonatomic,
        };
        
        class_addProperty(entityClass,
                          fastPrimitiveName,
                          propAttrs,
                          sizeof(propAttrs)/sizeof(*propAttrs));
    }
    
    SEL fastPrimitiveGetter = sel_registerName(fastPrimitiveName);
    
    //- (void)insertObject:(NSManagedObject *)value in<#Key#>AtIndex:(NSUInteger)idx;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"insertObject:in%@AtIndex:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSManagedObject *value, NSUInteger idx) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
            [_s willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:relationshipName];
            [primitive insertObject:value atIndex:idx];
            [_s didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSManagedObject *)[0],
            @encode(NSUInteger)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)removeObjectFrom<#Key#>AtIndex:(NSUInteger)idx;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"removeObjectFrom%@AtIndex:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSUInteger idx) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
            [_s willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:relationshipName];
            [primitive removeObjectAtIndex:idx];
            [_s didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSUInteger)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)insert<#Key#>:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"insert%@:atIndexes:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSArray *objects, NSIndexSet *indexes) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            [_s willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:relationshipName];
            [primitive insertObjects:objects atIndexes:indexes];
            [_s didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSArray *)[0],
            @encode(NSIndexSet *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)remove<#Key#>AtIndexes:(NSIndexSet *)indexes;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"remove%@AtIndexes:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSIndexSet *indexes) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            [_s willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:relationshipName];
            [primitive removeObjectsAtIndexes:indexes];
            [_s didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSIndexSet *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)replaceObjectIn<#Key#>AtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"replaceObjectIn%@AtIndex:withObject:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSUInteger idx, NSManagedObject *obj) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
            [_s willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:relationshipName];
            [primitive replaceObjectAtIndex:idx withObject:obj];
            [_s didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexSet forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSUInteger)[0],
            @encode(NSManagedObject *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)replace<#Key#>AtIndexes:(NSIndexSet *)indexes with<#Key#>:(NSArray *)values;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"replace%@AtIndexes:with%@:", capitalizedName, capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSIndexSet *indexes, NSArray *objects) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            [_s willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:relationshipName];
            [primitive replaceObjectsAtIndexes:indexes withObjects:objects];
            [_s didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSIndexSet *)[0],
            @encode(NSArray *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)add<#Key#>Object:(NSManagedObject *)value;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"add%@Object:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSManagedObject *obj) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:[primitive count]];
            [_s willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:relationshipName];
            [primitive addObject:obj];
            [_s didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexSet forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSManagedObject *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)remove<#Key#>Object:(NSManagedObject *)value;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"remove%@Object:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSManagedObject *obj) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            const NSUInteger idx = [primitive indexOfObject:obj];
            if (idx == NSNotFound)
                return;
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:idx];
            [_s willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:relationshipName];
            [primitive removeObjectAtIndex:idx];
            [_s didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexSet forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSManagedObject *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)add<#Key#>:(NSOrderedSet *)values;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"add%@:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSOrderedSet *objects) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSArray *newObjects = [objects objectsAtIndexes:[objects indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return ![primitive containsObject:obj];
            }]];
            
            const NSUInteger newObjectCount = [newObjects count];
            if (newObjectCount == 0)
                return;
            
            const NSRange insertionRange = {
                .location = [primitive count],
                .length = newObjectCount,
            };
            
            NSIndexSet *insertionIndexes = [[NSIndexSet alloc] initWithIndexesInRange:insertionRange];
            [_s willChange:NSKeyValueChangeInsertion valuesAtIndexes:insertionIndexes forKey:relationshipName];
            [primitive addObjectsFromArray:newObjects];
            [_s didChange:NSKeyValueChangeInsertion valuesAtIndexes:insertionIndexes forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSOrderedSet *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
    
    //- (void)remove<#Key#>:(NSOrderedSet *)values;
    {
        SEL sel = sel_registerName([[[NSString alloc] initWithFormat:@"remove%@:", capitalizedName] UTF8String]);
        IMP imp = imp_implementationWithBlock(^(NSManagedObject *_s, NSOrderedSet *objects) {
            [_s willAccessValueForKey:relationshipName];
            NSMutableOrderedSet *primitive = objc_msgSend(_s, fastPrimitiveGetter);
            [_s didAccessValueForKey:relationshipName];
            
            NSMutableIndexSet *removalIndexes = [NSMutableIndexSet new];
            [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                const NSUInteger currentIdx = [primitive indexOfObject:obj];
                if (currentIdx != NSNotFound)
                    [removalIndexes addIndex:currentIdx];
            }];
            
            if ([removalIndexes count] == 0)
                return;
            
            [_s willChange:NSKeyValueChangeRemoval valuesAtIndexes:removalIndexes forKey:relationshipName];
            [primitive removeObjectsAtIndexes:removalIndexes];
            [_s didChange:NSKeyValueChangeRemoval valuesAtIndexes:removalIndexes forKey:relationshipName];
        });
        const char *encoding = (const char []){
            @encode(void)[0],
            @encode(NSManagedObject *)[0],
            @encode(SEL)[0],
            @encode(NSOrderedSet *)[0],
        };
        class_replaceMethod(entityClass, sel, imp, encoding);
    }
}

@end
