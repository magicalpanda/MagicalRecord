//
//  Copyright © 2015 Magical Panda Software LLC. All rights reserved.
//
//  The following preprocessor macros can be used to adopt the new nullability annotations and generics
//  features available in Xcode 7, while maintaining backwards compatibility with earlier versions of
//  Xcode that do not support these features.
//
//  Originally taken from https://gist.github.com/smileyborg/d513754bc1cf41678054

#ifndef MagicalRecordXcode7CompatibilityMacros_h
#define MagicalRecordXcode7CompatibilityMacros_h

#if __has_feature(nullability)
#define MR_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#define MR_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#define MR_nullable nullable
#define MR_nonnull nonnull
#define __MR_nullable __nullable
#define __MR_nonnull __nonnull
#else
#define MR_ASSUME_NONNULL_BEGIN
#define MR_ASSUME_NONNULL_END
#define MR_nullable
#define MR_nonnull
#define __MR_nullable
#define __MR_nonnull
#endif

#if __has_feature(objc_generics)
#define MR_GENERIC(class, ...) class<__VA_ARGS__>
#define MR_GENERIC_TYPE(type) type
#define __MR_kindof(class) __kindof class
#else
#define MR_GENERIC(class, ...) class
#define MR_GENERIC_TYPE(type) id
#define __MR_kindof(class) id
#endif

#define MR_NSArrayOfNSManagedObjects MR_GENERIC(NSArray, __MR_kindof(NSManagedObject) *) *

#endif /* MagicalRecordXcode7CompatibilityMacros_h */
