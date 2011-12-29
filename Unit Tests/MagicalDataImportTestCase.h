//
//  MagicalDataImportTestCase.h
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

@interface MagicalDataImportTestCase : GHTestCase

@property (nonatomic, retain) id testEntityData;
@property (nonatomic, retain) id testEntity;

- (Class) testEntityClass;

@end
