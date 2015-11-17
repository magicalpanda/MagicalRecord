//
//  FixtureHelpers.h
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

@import XCTest;

@interface FixtureHelpers : NSObject

+ (id)dataFromPListFixtureNamed:(NSString *)fixtureName;
+ (id)dataFromJSONFixtureNamed:(NSString *)fixtureName;

@end

@interface XCTestCase (FixtureHelpers)

- (id)dataFromJSONFixture;

@end
