//
//  NSManagedObjectModel+KCOrderedAccessorFix.h
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

#import <CoreData/NSManagedObjectModel.h>

@class NSEntityDescription;
@class NSRelationshipDescription;

@interface NSManagedObjectModel (KCOrderedAccessorFix)

/**
 Generates the appropriate ordered KVC-compliant accessor methods for any ordered to-many relationships on its entities
 @see NSManagedObjectModel#kc_generateOrderedSetAccessorsForEntity:
 */
- (void)kc_generateOrderedSetAccessors;

/**
 Generates the appropriate ordered KVC-compliant accessor methods for any ordered to-many relationships in `entity`
 @param entity the ordered, to-many relationship to process.
 @see NSManagedObjectModel#kc_generateOrderedSetAccessorsForRelationship:
 */
- (void)kc_generateOrderedSetAccessorsForEntity:(NSEntityDescription *)entity;

/**
 @brief Generates the appropriate ordered KVC-compliant accessor methods.
 
 The following "CoreDataGeneratedAccessors" methods are generated, where <#Key#> is the capitalized version of the relationship name:
 - (void)insertObject:(NSManagedObject *)value in<#Key#>AtIndex:(NSUInteger)idx;
 - (void)removeObjectFrom<#Key#>AtIndex:(NSUInteger)idx;
 - (void)insert<#Key#>:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
 - (void)remove<#Key#>AtIndexes:(NSIndexSet *)indexes;
 - (void)replaceObjectIn<#Key#>AtIndex:(NSUInteger)idx withObject:(NSManagedObject *)value;
 - (void)replace<#Key#>AtIndexes:(NSIndexSet *)indexes with<#Key#>:(NSArray *)values;
 - (void)add<#Key#>Object:(NSManagedObject *)value;
 - (void)remove<#Key#>Object:(NSManagedObject *)value;
 - (void)add<#Key#>:(NSOrderedSet *)values;
 - (void)remove<#Key#>:(NSOrderedSet *)values;
 
 @param relationship the ordered, to-many relationship to process.
 */
- (void)kc_generateOrderedSetAccessorsForRelationship:(NSRelationshipDescription *)relationship;

@end
