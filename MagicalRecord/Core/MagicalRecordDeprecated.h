//
//  Created by Tony Arnold on 10/04/2014.
//  Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//

#define MR_DEPRECATED_AND_REPLACED_BY(METHOD) __attribute__((deprecated("This method has been deprecated. Please use `" METHOD "` instead.")))
#define MR_DEPRECATED_WILL_BE_REMOVED_IN(VERSION) __attribute__((deprecated("This method has been deprecated and will be removed in MagicalRecord " VERSION ".")))
#define MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE(VERSION, METHOD) __attribute__((deprecated("This method has been deprecated and will be removed in MagicalRecord " VERSION ". Please use `" METHOD "` instead.")))
