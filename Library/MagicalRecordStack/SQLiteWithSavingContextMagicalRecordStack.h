//
//  ThreadedSQLiteMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "SQLiteMagicalRecordStack.h"

@interface SQLiteWithSavingContextMagicalRecordStack : SQLiteMagicalRecordStack

@property (nonatomic, strong, readonly) NSManagedObjectContext *savingContext;

@end
