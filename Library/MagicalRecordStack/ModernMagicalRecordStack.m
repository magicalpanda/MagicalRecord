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
#import "MagicalRecordLogging.h"


@implementation DSManagedObjectContext {
  NSString *ds_name;
}
#ifdef DEBUG
- (void)dealloc
{
  MRLogVerbose(@"DSManagedObjectContext dealloc with name: %@", ds_name);
}
#endif

- (void)setName:(NSString *)name
{
  ds_name = name.copy;
  [super setName:name];
}
@end

@interface ModernMagicalRecordStack ()
@end

@implementation ModernMagicalRecordStack
@synthesize context = _context;

- (NSManagedObjectContext *) context
{
  if (_savingContext == nil)
  {
    _savingContext = [DSManagedObjectContext MR_privateQueueContext];
    [_savingContext setPersistentStoreCoordinator:[self coordinator]];
  }
  
  if (_context == nil)
  {
    _context = [DSManagedObjectContext MR_mainQueueContext];
    [_context setParentContext:_savingContext];
  }
  
  return _context;
}

- (NSManagedObjectContext *)newConfinementContext;
{
  NSManagedObjectContext *context = [DSManagedObjectContext MR_privateQueueContext];
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
