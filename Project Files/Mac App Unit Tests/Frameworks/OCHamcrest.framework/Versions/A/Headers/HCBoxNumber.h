//
//  OCHamcrest - HCBoxNumber.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#ifdef __cplusplus

namespace hamcrest {

/**
    Boxes a scalar value in an NSNumber, specialized per type.
    @ingroup number_matchers
 */
template <typename T>
inline
NSNumber *boxNumber(T value)
    { return nil; }

template <>
inline
NSNumber *boxNumber(BOOL value)
    { return [NSNumber numberWithBool:value]; }

template <>
inline
NSNumber *boxNumber(char value)
    { return [NSNumber numberWithChar:value]; }

template <>
inline
NSNumber *boxNumber(double value)
    { return [NSNumber numberWithDouble:value]; }

template <>
inline
NSNumber *boxNumber(float value)
    { return [NSNumber numberWithFloat:value]; }

template <>
inline
NSNumber *boxNumber(int value)
    { return [NSNumber numberWithInt:value]; }

template <>
inline
NSNumber *boxNumber(long value)
    { return [NSNumber numberWithLong:value]; }

template <>
inline
NSNumber *boxNumber(long long value)
    { return [NSNumber numberWithLongLong:value]; }

template <>
inline
NSNumber *boxNumber(short value)
    { return [NSNumber numberWithShort:value]; }

template <>
inline
NSNumber *boxNumber(unsigned char value)
    { return [NSNumber numberWithUnsignedChar:value]; }

template <>
inline
NSNumber *boxNumber(unsigned int value)
    { return [NSNumber numberWithUnsignedInt:value]; }

template <>
inline
NSNumber *boxNumber(unsigned long value)
    { return [NSNumber numberWithUnsignedLong:value]; }

template <>
inline
NSNumber *boxNumber(unsigned long long value)
    { return [NSNumber numberWithUnsignedLongLong:value]; }

template <>
inline
NSNumber *boxNumber(unsigned short value)
    { return [NSNumber numberWithUnsignedShort:value]; }

}   // namespace hamcrest

#endif  // __cplusplus
