//
//  NSManagedObject+Proxy.h
//  Progress
//
//  Created by Brian King on 4/1/11.
//  Copyright 2011 King Software Design. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSManagedObject (Proxy)

- (id) inContext:(NSManagedObjectContext*)context;
@end
