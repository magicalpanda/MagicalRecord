//
//  ModernMagicalRecordStack.m
//  DSMagicalRecord
//
//  Created by Alexander Belyavskiy on 15.09.14.
//  Copyright (c) 2014 Alexander Belyavskiy. All rights reserved.
//

#import "ModernMagicalRecordStack.h"
#import "MagicalRecordStack+Private.h"
#import "SQLiteWithSavingContextMagicalRecordStack.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSDictionary+MagicalRecordAdditions.h"
#import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"

@interface ModernMagicalRecordStack ()
@property (nonatomic, strong, readwrite) NSManagedObjectContext *savingContext;
@end

@implementation ModernMagicalRecordStack
@synthesize context = _context;

- (NSManagedObjectContext *) context
{
  if (_savingContext == nil)
  {
    _savingContext = [NSManagedObjectContext MR_privateQueueContext];
    [_savingContext setPersistentStoreCoordinator:[self coordinator]];
  }
  
  if (_context == nil)
  {
    _context = [NSManagedObjectContext MR_mainQueueContext];
    [_context setParentContext:_savingContext];
  }
  
  return _context;
}

- (NSManagedObjectContext *)newConfinementContext;
{
  NSManagedObjectContext *context = [NSManagedObjectContext MR_privateQueueContext];
  [context setParentContext:[self context]];
  return context;
}

- (NSPersistentStoreCoordinator *) createCoordinatorWithOptions:(NSDictionary *)options
{
  NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
  
  NSMutableDictionary *storeOptions = [[self defaultStoreOptions] mutableCopy];
  [storeOptions addEntriesFromDictionary:self.storeOptions];
  [storeOptions addEntriesFromDictionary:[NSDictionary MR_autoMigrationOptions]];
    
  [coordinator MR_addAutoMigratingSqliteStoreAtURL:self.storeURL withOptions:storeOptions];
  
  return coordinator;
}

@end
