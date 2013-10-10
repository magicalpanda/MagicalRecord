//
//  NSPersistentStoreCoordinator+MagicalRecordSpec.m
//  MagicalRecord
//
//  Created by Mike Gottlieb on 9/28/13.
//  Copyright (c) 2013 Magical Panda Software LLC. All rights reserved.
//

#define EXP_SHORTHAND
#import "Expecta.h"
#import "Specta.h"

// Project
#import "NSPersistentStoreCoordinator+MagicalRecord.h"

SpecBegin(NSPersistentStoreCoordinatorMagicalRecord)

describe(@"NSPersistentStorCoordinator+MagicalRecord", ^{
    describe(@"when creating an in-memory store coordinator", ^{
        afterEach(^{
            [MagicalRecord cleanUp];
        });
        
        it(@"should use the default managed object model", ^{
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
            [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
            NSPersistentStoreCoordinator *coord = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStore];
            expect([coord managedObjectModel]).to.equal(model);
        });
        
        it(@"should use a different managed object model when provided", ^{
            NSManagedObjectModel *model1 = [[NSManagedObjectModel alloc] init];
            NSManagedObjectModel *model2 = [[NSManagedObjectModel alloc] init];
            [NSManagedObjectModel MR_setDefaultManagedObjectModel:model1];
            NSPersistentStoreCoordinator *coord = [NSPersistentStoreCoordinator MR_coordinatorWithInMemoryStoreAndManagedObjectModel:model2];
            expect([coord managedObjectModel] != model1).to.beTruthy();
            expect([coord managedObjectModel] == model2).to.beTruthy();
        });
    });
    
    describe(@"when creating an auto-migrating sqlite store", ^{
        __block NSPersistentStoreCoordinator *coord;
        
        afterEach(^{
            NSError *error = nil;
            for (NSPersistentStore *store in [coord persistentStores]) {
                [[NSFileManager defaultManager] removeItemAtURL:store.URL error:&error];
            }
            coord = nil;
            [MagicalRecord cleanUp];
        });
        
        it(@"should use the default managed object model", ^{
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] init];
            [NSManagedObjectModel MR_setDefaultManagedObjectModel:model];
            NSString *storeName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            coord = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName];
            expect([coord managedObjectModel]).to.equal(model);
        });
        
        it(@"should use a different managed object model when provided", ^{
            NSManagedObjectModel *model1 = [[NSManagedObjectModel alloc] init];
            NSManagedObjectModel *model2 = [[NSManagedObjectModel alloc] init];
            NSString *storeName = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [NSManagedObjectModel MR_setDefaultManagedObjectModel:model1];
            coord = [NSPersistentStoreCoordinator MR_coordinatorWithAutoMigratingSqliteStoreNamed:storeName andManagedObjectModel:model2];
            expect([coord managedObjectModel] != model1).to.beTruthy();
            expect([coord managedObjectModel] == model2).to.beTruthy();
        });
    });
});

SpecEnd
