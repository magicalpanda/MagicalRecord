//
//  MagicalDataImportTestCase.m
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalDataImportTestCase.h"

@implementation MagicalDataImportTestCase

@synthesize testEntity;

- (void) setUp
{
    [NSManagedObjectModel setDefaultManagedObjectModel:[NSManagedObjectModel managedObjectModelNamed:@"TestModel.momd"]];
    [MagicalRecordHelpers setupCoreDataStackWithInMemoryStore];
//    [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:@"DataImportTests.sqlite"];
    
    if ([self respondsToSelector:@selector(setupTestData)])
    {
        [self performSelector:@selector(setupTestData)];
    }
    
    id singleEntity = [self dataFromJSONFixture];
    
    self.testEntity = [[self testEntityClass] MR_importFromDictionary:singleEntity];
    
    [[NSManagedObjectContext defaultContext] save];
}

- (void) tearDown
{
    [MagicalRecordHelpers cleanUp];
//    
//    NSURL *tempStoreURL = [NSPersistentStore MR_urlForStoreName:@"DataImportTests.sqlite"];
//    NSError *error = nil;
//    [[NSFileManager defaultManager] removeItemAtPath:[tempStoreURL path] error:&error];
//    if (error)
//    {
//        NSLog(@"Unable to delete temporary store at %@: %@", tempStoreURL, error);
//    }
}

- (Class) testEntityClass;
{
    return [NSManagedObject class];
}

-(BOOL)shouldRunOnMainThread
{
    return YES;
}

@end
