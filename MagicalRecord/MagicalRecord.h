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
