//
//  Created by Tony Arnold on 10/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

//Warning to express this problem http://saulmora.com/2013/09/15/why-contextforcurrentthread-doesn-t-work-in-magicalrecord/
#define MR_INTERNALLY_USING_DEPRECATED_METHODS __attribute__((deprecated("This method uses one or more deprecated methods (like MR_contextForCurrentThread http://goo.gl/t9WNpF)")))
#define MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0 __attribute__((deprecated("This method will be removed in MagicalRecord 3.0.")))
#define MR_DEPRECATED_WILL_BE_REMOVED_IN_3_0_USE(MSG) __attribute__((deprecated("This method will be removed in MagicalRecord 3.0. " MSG)))
