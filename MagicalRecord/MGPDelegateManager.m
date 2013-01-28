//
//  MGPDelegateManager.m
//  NSBrief
//
//  Created by Saul Mora on 1/27/13.
//  Copyright (c) 2013 Magical Panda Software. All rights reserved.
//

#import "MGPDelegateManager.h"

@interface MGPDelegateManager ()

@end


@implementation MGPDelegateManager

-(id)init
{
	_proxiedObject=nil;
	_justResponded=NO;
	_logOnNoResponse=NO;
	return self;
}

-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *sig = [[_proxiedObject class] instanceMethodSignatureForSelector:selector];
	if (sig == nil)
	{
		sig = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
	}
	_justResponded = NO;
	return sig;
}

-(void)forwardInvocation:(NSInvocation*)invocation
{
	if (_proxiedObject==nil)
	{
		if(_logOnNoResponse)
        {
            NSLog(@"Warning: proxiedObject is nil! This is a debugging message!");
        }
		return;
	}
	if ([_proxiedObject respondsToSelector:[invocation selector]])
	{
		[invocation invokeWithTarget:_proxiedObject];
		_justResponded=YES;
	}
	else if(_logOnNoResponse)
	{
		NSLog(@"Object \"%@\" failed to respond to delegate message \"%@\"! This is a debugging message.", [[self proxiedObject] class], NSStringFromSelector([invocation selector]));
	}
	return;
}

@end
