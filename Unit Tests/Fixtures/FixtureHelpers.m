//
//  FixtureHelpers.m
//  Magical Record
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import "FixtureHelpers.h"

@implementation FixtureHelpers

+ (id) dataFromPListFixtureNamed:(NSString *)fixtureName
{
    NSString *resource = [[NSBundle mainBundle] pathForResource:fixtureName ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:resource];
    
    return [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:nil error:nil];
}

+ (id) dataFromJSONFixtureNamed:(NSString *)fixtureName
{
    return nil;
}

@end
