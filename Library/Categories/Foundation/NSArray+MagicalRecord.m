//
//  Created by Tony Arnold on 8/04/2014. Originally proposed by Raymond Edwards on 09/07/2013
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "NSArray+MagicalRecord.h"
#import "MagicalRecordStack.h"
#import "NSManagedObject+MagicalRecord.h"

@implementation NSArray (MagicalRecord)

- (NSArray *) MR_entitiesInContext:(NSManagedObjectContext *)context
{
    NSMutableArray *objectsInContext = [NSMutableArray new];

    for (id object in self)
    {
        NSAssert([object isKindOfClass:[NSManagedObject class]], @"Expected NSManagedObject or subclass in array, received %@", NSStringFromClass([object class]));

        NSManagedObject *managedObjectInContext = [object MR_inContext:context];

        if ([managedObjectInContext isKindOfClass:[NSManagedObject class]]) {
            [objectsInContext addObject:managedObjectInContext];
        }
    }

    return objectsInContext;
}

- (void) MR_deleteEntities
{
    [self MR_deleteEntitiesInContext:[[MagicalRecordStack defaultStack] context]];
}

- (void) MR_deleteEntitiesInContext:(NSManagedObjectContext *)otherContext
{
    for (id object in self)
    {
        NSAssert([object isKindOfClass:[NSManagedObject class]], @"Expected NSManagedObject or subclass in array, received %@", NSStringFromClass([object class]));

        [object MR_deleteInContext:otherContext];
    }
}

@end
