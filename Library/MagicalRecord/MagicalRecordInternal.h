//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Magical Panda Software, LLC All rights reserved.
//

#import <Foundation/Foundation.h>

/**

 @since 2.0.0
 */
@interface MagicalRecord : NSObject

/**
 Cleans up by setting the default stack to nil.
 
 @since 2.0.0
 */
+ (void) cleanUp;

/**
 Determines the store file name your app should use. This method is used by the MagicalRecord SQLite stacks when a store file is not specified. The file name returned is in the form "<ApplicationName>.sqlite". ApplicationName is retrieved from the app's info dictionary retrieved from the method [[NSBundle mainBundle] infoDictionary]

 @return String of the form <ApplicationName>.sqlite
 @since 2.0.0
 */
+ (NSString *) defaultStoreName;

@end
