//
//  MagicalRecord.h
//
//  Created by Saul Mora on 28/07/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

//! Project version number for MagicalRecord.
FOUNDATION_EXPORT double MagicalRecordVersionNumber;

//! Project version string for MagicalRecord.
FOUNDATION_EXPORT const unsigned char MagicalRecordVersionString[];

#if __has_include(<MagicalRecord/MagicalRecord.h>)

#import <MagicalRecord/MagicalRecordXcode7CompatibilityMacros.h>
#import <MagicalRecord/MagicalRecordInternal.h>
#import <MagicalRecord/MagicalRecordLogging.h>

#import <MagicalRecord/MagicalRecord+Actions.h>
#import <MagicalRecord/MagicalRecord+ErrorHandling.h>
#import <MagicalRecord/MagicalRecord+Options.h>
#import <MagicalRecord/MagicalRecord+Setup.h>
#import <MagicalRecord/MagicalRecord+iCloud.h>

#import <MagicalRecord/NSManagedObject+MagicalRecord.h>
#import <MagicalRecord/NSManagedObject+MagicalRequests.h>
#import <MagicalRecord/NSManagedObject+MagicalFinders.h>
#import <MagicalRecord/NSManagedObject+MagicalAggregation.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalRecord.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalChainSave.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalObserving.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalSaves.h>
#import <MagicalRecord/NSManagedObjectContext+MagicalThreading.h>
#import <MagicalRecord/NSPersistentStoreCoordinator+MagicalRecord.h>
#import <MagicalRecord/NSManagedObjectModel+MagicalRecord.h>
#import <MagicalRecord/NSPersistentStore+MagicalRecord.h>

#import <MagicalRecord/MagicalImportFunctions.h>
#import <MagicalRecord/NSManagedObject+MagicalDataImport.h>
#import <MagicalRecord/NSNumber+MagicalDataImport.h>
#import <MagicalRecord/NSObject+MagicalDataImport.h>
#import <MagicalRecord/NSString+MagicalDataImport.h>
#import <MagicalRecord/NSAttributeDescription+MagicalDataImport.h>
#import <MagicalRecord/NSRelationshipDescription+MagicalDataImport.h>
#import <MagicalRecord/NSEntityDescription+MagicalDataImport.h>

#else

#import "MagicalRecordXcode7CompatibilityMacros.h"
#import "MagicalRecordInternal.h"
#import "MagicalRecordLogging.h"

#import "MagicalRecord+Actions.h"
#import "MagicalRecord+ErrorHandling.h"
#import "MagicalRecord+Options.h"
#import "MagicalRecord+Setup.h"
#import "MagicalRecord+iCloud.h"

#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObject+MagicalRequests.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObject+MagicalAggregation.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalChainSave.h"
#import "NSManagedObjectContext+MagicalObserving.h"
#import "NSManagedObjectContext+MagicalSaves.h"
#import "NSManagedObjectContext+MagicalThreading.h"
#import "NSPersistentStoreCoordinator+MagicalRecord.h"
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

#endif