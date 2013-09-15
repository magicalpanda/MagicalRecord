//
//  MagicalRecord+Options.h
//  Magical Record
//
//  Created by Saul Mora on 3/6/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecord.h"

@interface MagicalRecord (Options)

//global options
// enable/disable logging
// add logging provider
// autocreate new PSC per Store
// autoassign new instances to default store

+ (BOOL) shouldAutoCreateManagedObjectModel;
+ (void) setShouldAutoCreateManagedObjectModel:(BOOL)shouldAutoCreate;
+ (BOOL) shouldAutoCreateDefaultPersistentStoreCoordinator;
+ (void) setShouldAutoCreateDefaultPersistentStoreCoordinator:(BOOL)shouldAutoCreate;
+ (void) setShouldDeleteStoreOnModelMismatch:(BOOL)shouldDeleteStoreOnModelMismatch;

/*!
 @method shouldDeleteStoreOnModelMistmatch
 @abstract If true, when configuring the persistant store coordinator, and Magical Record encounters a store that does not match the model, it will attempt to remove it and re-create a new store.
 This is extremely useful during development where every model change could potentially require a delete/reinstall of the app.
 */
+ (BOOL) shouldDeleteStoreOnModelMismatch;


@end
