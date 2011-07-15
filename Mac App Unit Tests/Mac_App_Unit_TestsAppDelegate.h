//
//  Mac_App_Unit_TestsAppDelegate.h
//  Mac App Unit Tests
//
//  Created by Saul Mora on 7/15/11.
//  Copyright 2011 Magical Panda Software LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Mac_App_Unit_TestsAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
