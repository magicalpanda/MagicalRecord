//
//  MagicalDataImportTestCase.h
//  Magical Record
//
//  Created by Saul Mora on 8/16/11.
//  Copyright (c) 2011 Magical Panda Software LLC. All rights reserved.
//

#ifdef MAC_PLATFORM_ONLY
#import <GHUnit/GHUnit.h>
#else
#import <GHUnitIOS/GHUnit.h>
#endif
@interface MagicalDataImportTestCase : GHTestCase

@property (nonatomic, retain) id testEntityData;
@property (nonatomic, retain) id testEntity;

- (Class) testEntityClass;

@end
