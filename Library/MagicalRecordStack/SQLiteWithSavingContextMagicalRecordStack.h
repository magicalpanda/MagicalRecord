//
//  ThreadedSQLiteMagicalRecordStack.h
//  MagicalRecord
//
//  Created by Saul Mora on 9/15/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#import "SQLiteMagicalRecordStack.h"

NS_ASSUME_NONNULL_BEGIN
@interface SQLiteWithSavingContextMagicalRecordStack : SQLiteMagicalRecordStack

@property (nonatomic, strong, readonly) NSManagedObjectContext *savingContext;

@end
NS_ASSUME_NONNULL_END
