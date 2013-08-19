//
//  NSArray+MagicalRecord.h
//
//  Created by Raymond Edwards on 2013-07-09.
//

#import <CoreData/CoreData.h>

@interface NSArray (MagicalRecord)

- (NSArray *) MR_inContext:(NSManagedObjectContext *)otherContext;

- (void) MR_deleteEntities;
- (void) MR_deleteInContext:(NSManagedObjectContext *)otherContext;

@end
