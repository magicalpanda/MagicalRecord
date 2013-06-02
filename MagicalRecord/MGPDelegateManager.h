//
//  MGPDelegateManager.h
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPDelegateManager : NSProxy

@property (nonatomic, assign, readonly) BOOL justResponded;
@property (nonatomic, assign) BOOL logOnNoResponse;
@property (nonatomic, weak) id proxiedObject;

- (id) init;

@end
