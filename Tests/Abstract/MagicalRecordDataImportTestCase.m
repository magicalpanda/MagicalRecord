//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import "MagicalRecordDataImportTestCase.h"
#import "FixtureHelpers.h"

@implementation MagicalRecordDataImportTestCase

- (void)setUp
{
    [super setUp];
    self.testEntityData = [self dataFromJSONFixture];
}

@end
