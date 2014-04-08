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
#define MRDeprecated(MSG)
#else
#define MRDeprecated(MSG) __attribute((deprecated(MSG " (See MagicalRecordDeprecated.h to silence this warning)")))
#endif
