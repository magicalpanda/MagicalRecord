//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//


#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#ifndef NS_BLOCKS_AVAILABLE
#warning MagicalRecord requires blocks
#endif

#import "MagicalRecordInternal.h"
#import "MagicalRecord+Options.h"
#import "MagicalRecord+Setup.h"
#import "MagicalRecord+VersionInformation.h"

#import "MagicalRecordStack.h"
#import "MagicalRecordStack+Actions.h"
#import "SQLiteMagicalRecordStack.h"
#import "SQLiteWithSavingContextMagicalRecordStack.h"
#import "ClassicSQLiteMagicalRecordStack.h"
#import "ClassicWithBackgroundCoordinatorSQLiteMagicalRecordStack.h"

#import "InMemoryMagicalRecordStack.h"

#import "AutoMigratingMagicalRecordStack.h"
#import "AutoMigratingWithSourceAndTargetModelMagicalRecordStack.h"
#import "ManuallyMigratingMagicalRecordStack.h"

#import "NSArray+MagicalRecord.h"

#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObject+MagicalAggregation.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalSaves.h"

#import "NSPersistentStoreCoordinator+MagicalRecord.h"
#import "NSPersistentStoreCoordinator+MagicalAutoMigrations.h"
#import "NSPersistentStoreCoordinator+MagicalManualMigrations.h"
#import "NSPersistentStoreCoordinator+MagicalInMemoryStoreAdditions.h"

#import "NSManagedObjectModel+MagicalRecord.h"
#import "NSPersistentStore+MagicalRecord.h"

#import "MagicalImportFunctions.h"
#import "NSManagedObject+MagicalDataImport.h"
#import "NSNumber+MagicalDataImport.h"
#import "NSObject+MagicalDataImport.h"
#import "NSString+MagicalDataImport.h"
#import "NSAttributeDescription+MagicalDataImport.h"
#import "NSRelationshipDescription+MagicalDataImport.h"
#import "NSEntityDescription+MagicalDataImport.h"
#import "NSError+MagicalRecordErrorHandling.h"

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
#import "NSManagedObject+MagicalFetching.h"
#import "NSFetchedResultsController+MagicalFetching.h"
#endif

#define MR_SHORTHAND 1
#import "MagicalRecordShorthand.h"

#endif // ifdef __OBJC__
