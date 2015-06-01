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
