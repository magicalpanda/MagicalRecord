//
//  NSManagedObject+Proxy.m
//  Progress
//
//  Created by Brian King on 4/1/11.
//  Copyright 2011 King Software Design. All rights reserved.
//

#import "NSManagedObject+Proxy.h"
#import "NSManagedObject+ActiveRecord.h"

@interface BKThisContextManagedObject : NSObject {
	NSManagedObject *_proxyObject;
}

@end


@implementation BKThisContextManagedObject

- (id) initWithManagedObject:(NSManagedObject*)theObject inContext:(NSManagedObjectContext*)context {
	if ((self = [super init])) {
        NSError *error = nil;
        _proxyObject = [[context existingObjectWithID:[theObject objectID] error:&error] retain];
        [ActiveRecordHelpers handleErrors:error];
	}
	return self;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:_proxyObject];
    [_proxyObject release];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [_proxyObject methodSignatureForSelector:aSelector];
}

@end


@implementation NSManagedObject (Proxy)

- (id) inContext:(NSManagedObjectContext*)context {
    return [[[BKThisContextManagedObject alloc] initWithManagedObject:self inContext:context] autorelease];
}

@end
