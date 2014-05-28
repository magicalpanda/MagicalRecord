//
// Created by Tony Arnold on 25/03/2014.
// Copyright (c) 2014 Magical Panda Software LLC. All rights reserved.
//
// Shamelessly taken from ReactiveCocoa's `RACDeprecated.h` header

// Define this constant before importing any MagicalRecord headers to
// temporarily silence MR 3.0 deprecation warnings.
//
// Please remember to fix them up at some point, because any deprecated APIs
// will be removed by the time MagicalRecord hits 4.0.

#ifdef WE_PROMISE_TO_MIGRATE_TO_MAGICALRECORD_3_0
#define MR_DEPRECATED_IN_3_0_PLEASE_USE(METHOD)
#else
#define MR_DEPRECATED_IN_3_0_PLEASE_USE(METHOD) MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE("4.0", METHOD " See MagicalRecordDeprecated.h to silence this warning.")
#endif

#define MR_DEPRECATED_WILL_BE_REMOVED_IN(VERSION) __attribute__((deprecated("This method has been deprecated and will be removed in MagicalRecord " VERSION ".")))
#define MR_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE(VERSION, METHOD) __attribute__((deprecated("This method has been deprecated and will be removed in MagicalRecord " VERSION ". Please use `" METHOD "` instead.")))
