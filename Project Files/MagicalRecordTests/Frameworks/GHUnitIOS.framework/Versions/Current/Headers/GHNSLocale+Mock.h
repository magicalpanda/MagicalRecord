//
//  GHNSLocale+Mock.h
//  GHUnit
//
//  Created by Gabriel Handford on 4/13/09.
//  Copyright 2009. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

/*!
 Category for overriding the current locale at runtime.

     #import "GHNSLocale+Mock.h"
     // This aliases the currentLocale method and with the specified locale identifier
     [NSLocale gh_setLocaleIdentifier:@"en_GB"];
      
     [[NSLocale currentLocale] localeIdentifier] == "en_GB"

 */
@interface NSLocale(GHMock)

/*!
 Set locale.
 @param localeIdentifier Locale identifier, e.g. "en_US"
 */
+ (void)gh_setLocaleIdentifier:(NSString *)localeIdentifier;

/*!
 Aliases to currentLocale with locale set from gh_setLocaleIdentifier.
 If not set, defaults to NSLocale with identifier en_US.
 */
+ (NSLocale *)gh_currentLocale;

/*!
 Set preferred languages. To reset, set to nil.
 @param preferredLanguages Preferred languages to set
 */
+ (void)gh_setPreferredLanguages:(NSArray *)preferredLanguages;

/*!
 Aliases to preferredLanguages set from gh_setPreferredLanguages.
 If not set, defaults to [@"en"].
 */
+ (NSArray *)gh_preferredLanguages;

@end
