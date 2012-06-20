//
//  MRFactoryObjectSelectorCaptureObject.m
//  MagicalRecord
//
//  Created by Saul Mora on 6/19/12.
//  Copyright (c) 2012 Magical Panda Software LLC. All rights reserved.
//

#import "MRFactoryObjectSelectorCaptureObject.h"
#import "MRFactoryObject.h"

@implementation MRFactoryObjectSelectorCaptureObject

+ (id) capturerWithFactory:(MRFactoryObject *)factory;
{
    MRFactoryObjectSelectorCaptureObject *capturer = [self new];
    capturer.factory = factory;
    return capturer;
}

//- (id)forwardingTargetForSelector:(SEL)aSelector;
//{
//    self.capturedSelector = aSelector;
//    return self.factory;
//}
////
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return [[self.factory factoryClass] instanceMethodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation;
{
    //just want to collect the selector, and absorb the invocation
    self.capturedSelector = anInvocation.selector;
    anInvocation.selector = @selector(completeSelectorCapture);
    [anInvocation invokeWithTarget:self.factory];
}

@end
