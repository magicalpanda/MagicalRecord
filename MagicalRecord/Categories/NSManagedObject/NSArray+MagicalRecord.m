//
//  NSArray+MagicalRecord.m
//
//  Created by Raymond Edwards on 2013-07-09.
//

#import "NSArray+MagicalRecord.h"
#import "NSManagedObject+MagicalRecord.h"

@implementation NSArray (MagicalRecord)

- (NSArray *) MR_inContext:(NSManagedObjectContext *)otherContext
{
  NSMutableArray *objectsInContext = [[NSMutableArray alloc] initWithCapacity:[self count]];
  
  for (id object in self)
  {
    NSAssert1([object isKindOfClass:[NSManagedObject class]], @"Expected NSManagedObject or subclass in array, received %@", NSStringFromClass([object class]));
    
    NSManagedObject *managedObjectInContext = [(NSManagedObject *)object MR_inContext:otherContext];
    [objectsInContext addObject:managedObjectInContext];
  }
  
  return objectsInContext;
}

- (void) MR_deleteEntities
{
  for (id object in self)
  {
    NSAssert1([object isKindOfClass:[NSManagedObject class]], @"Expected NSManagedObject or subclass in array, received %@", NSStringFromClass([object class]));
    
    [(NSManagedObject *)object MR_deleteEntity];
  }
}

- (void) MR_deleteInContext:(NSManagedObjectContext *)otherContext
{
  for (id object in self)
  {
    NSAssert1([object isKindOfClass:[NSManagedObject class]], @"Expected NSManagedObject or subclass in array, received %@", NSStringFromClass([object class]));
    
    [(NSManagedObject *)object MR_deleteInContext:otherContext];
  }
}

@end
