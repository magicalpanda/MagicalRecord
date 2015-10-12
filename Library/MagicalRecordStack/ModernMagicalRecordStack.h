//
//  ModernMagicalRecordStack.h
//  DSMagicalRecord
//
//  Created by Alexander Belyavskiy on 15.09.14.
//  Copyright (c) 2014 Alexander Belyavskiy. All rights reserved.
//

#import "SQLiteMagicalRecordStack.h"

@interface DSManagedObjectContext : NSManagedObjectContext

@end

@interface ModernMagicalRecordStack : SQLiteMagicalRecordStack
@property (nonatomic, strong, readwrite) NSManagedObjectContext *savingContext;
@end
