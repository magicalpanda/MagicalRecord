//
//  NSManagedObjectContext+ChainSaveTests.m
//  MagicalRecord
//
//  Created by Lee on 12/1/14.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordTestBase.h"
#import "NSManagedObjectContext+MagicalChainSave.h"
#import "SingleEntityWithNoRelationships.h"

@interface NSManagedObjectContext_ChainSaveTests : MagicalRecordTestBase

@end

@implementation NSManagedObjectContext_ChainSaveTests

- (void)testChainSave
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Chain Save Completed"];
    
    //Test if a new Object can save from child context to parent context
    __block NSManagedObjectID *childObjectID;

    NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];

    [defaultContext MR_saveWithBlock:^(NSManagedObjectContext *localContext) {
        SingleEntityWithNoRelationships *insertedObject = [SingleEntityWithNoRelationships MR_createEntityInContext:localContext];

        XCTAssertTrue(insertedObject.hasChanges);

        NSError *obtainIDsError;
        BOOL obtainIDsResult = [localContext obtainPermanentIDsForObjects:@[ insertedObject ] error:&obtainIDsError];

        XCTAssertTrue(obtainIDsResult);
        XCTAssertNil(obtainIDsError);

        childObjectID = [insertedObject objectID];

        XCTAssertNotNil(childObjectID);
        XCTAssertFalse(childObjectID.isTemporaryID);

    } completion:^(BOOL success, NSError *error) {

        //test parent and root saving context
        SingleEntityWithNoRelationships *parentObject = (SingleEntityWithNoRelationships *)[defaultContext objectWithID:childObjectID];

        XCTAssertNotNil(parentObject);

        NSManagedObjectContext *rootSavingContext = [NSManagedObjectContext MR_rootSavingContext];

        [rootSavingContext performBlockAndWait:^{
            SingleEntityWithNoRelationships *rootObject = (SingleEntityWithNoRelationships *)[rootSavingContext objectWithID:childObjectID];
            
            XCTAssertNotNil(rootObject);
        }];

        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

@end
