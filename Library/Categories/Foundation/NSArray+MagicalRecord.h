//
//  Created by Tony Arnold on 8/04/2014. Originally proposed by Raymond Edwards on 09/07/2013
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import <CoreData/CoreData.h>

/**
 Category methods for working with NSManagedObjects within NSArray instances.
 
 @since Available in v2.3 and later.
 */
@interface NSArray (MagicalRecord)

///------------------------
/// @name Entity Retrieval
///------------------------

/**
 Enumerates an array of NSManagedObjects and retrieves them from the specified context if possible. 
 If it's not possible to retrieve any of the managed objects from the specified context, they will not be included in the result.
 
 @param context Managed object context
 @return Array of NSManagedObjects in the specified context
 
 @since Available in v2.3 and later.
 */
- (NSArray *) MR_entitiesInContext:(NSManagedObjectContext *)context;

///-----------------------
/// @name Entity Deletion
///-----------------------

/**
 Deletes any managed objects in the array instance from the default context.
 
 @since Available in v2.3 and later.
 */
- (void) MR_deleteEntities;

/**
 Deletes any managed objects in the array instance from the specified context.
 @param context Managed object context
 
 @since Available in v2.3 and later.
 */
- (void) MR_deleteEntitiesInContext:(NSManagedObjectContext *)context;

@end
