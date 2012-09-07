//
//  MagicalRecordPersistenceStrategy.h
//  Magical Record
//
//  Created by Stephen J Vanterpool on 8/31/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MagicalRecordPersistenceStrategy <NSObject>
- (void)setUpContextsWithCoordinator:(NSPersistentStoreCoordinator *)coordinator;
- (NSManagedObjectContext *)contextToUseForBackgroundSaves;
@end
