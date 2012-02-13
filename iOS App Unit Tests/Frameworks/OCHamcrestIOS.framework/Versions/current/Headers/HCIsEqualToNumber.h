//
//  OCHamcrest - HCIsEqualToNumber.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

#import <OCHamcrestIOS/HCBaseMatcher.h>


/**
    Is the @c BOOL value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToBool
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToBool(BOOL value);

/**
    equalToBool(value) -
    Is the @c BOOL value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToBool, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToBool HC_equalToBool
#endif


/**
    Is the @c char value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToChar
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToChar(char value);

/**
    equalToChar(value) -
    Is the @c char value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToChar, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToChar HC_equalToChar
#endif


/**
    Is the @c double value, converted to an @c NSNumber, equal to another object? 

    @b Synonym: @ref equalToDouble
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToDouble(double value);

/**
    equalToDouble(value) -
    Is the @c double value, converted to an @c NSNumber, equal to another object? 

    Synonym for @ref HC_equalToDouble, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToDouble HC_equalToDouble
#endif

/**
    Is the @c float value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToFloat
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToFloat(float value);

/**
    equalToFloat(value) -
    Is the @c float value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToFloat, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToFloat HC_equalToFloat
#endif


/**
    Is the @c int value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToInt
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToInt(int value);

/**
    equalToInt(value) -
    Is the @c int value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToInt, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToInt HC_equalToInt
#endif


/**
    Is the @c long value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToLong
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToLong(long value);

/**
    equalToLong(value) -
    Is the @c long value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToLong, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToLong HC_equalToLong
#endif


/**
    Is the <code>long long</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToLongLong
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToLongLong(long long value);

/**
    equalToLongLong(value) -
    Is the <code>long long</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToLongLong, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToLongLong HC_equalToLongLong
#endif


/**
    Is the @c short value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToShort
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToShort(short value);

/**
    equalToShort(value) -
    Is the @c short value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToShort, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToShort HC_equalToShort
#endif


/**
    Is the <code>unsigned char</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedChar
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedChar(unsigned char value);

/**
    equalToUnsignedChar(value) -
    Is the <code>unsigned char</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedChar, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedChar HC_equalToUnsignedChar
#endif


/**
    Is the <code>unsigned int</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedInt
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedInt(unsigned int value);

/**
    equalToUnsignedInt(value) -
    Is the <code>unsigned int</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedInt, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedInt HC_equalToUnsignedInt
#endif


/**
    Is the <code>unsigned long</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedLong
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedLong(unsigned long value);

/**
    equalToUnsignedLong(value) -
    Is the <code>unsigned long</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedLong, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedLong HC_equalToUnsignedLong
#endif


/**
    Is the <code>unsigned long long</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedLongLong
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedLongLong(unsigned long long value);

/**
    equalToUnsignedLongLong(value) -
    Is the <code>unsigned long long</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedLongLong, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedLongLong HC_equalToUnsignedLongLong
#endif


/**
    Is the <code>unsigned short</code> value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedShort
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedShort(unsigned short value);

/**
    equalToUnsignedShort(value) -
    Is the <code>unsigned short</code> value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedShort, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedShort HC_equalToUnsignedShort
#endif


/**
    Is the @c NSInteger value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToInteger
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToInteger(NSInteger value);

/**
    equalToInteger(value) -
    Is the @c NSInteger value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToInteger, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToInteger HC_equalToInteger
#endif


/**
    Is the @c NSUInteger value, converted to an @c NSNumber, equal to another object?

    @b Synonym: @ref equalToUnsignedInteger
    @ingroup primitive_number_matchers
 */
OBJC_EXPORT id<HCMatcher> HC_equalToUnsignedInteger(NSUInteger value);

/**
    equalToUnsignedInteger(value) -
    Is the @c NSUInteger value, converted to an @c NSNumber, equal to another object?

    Synonym for @ref HC_equalToUnsignedInteger, available if @c HC_SHORTHAND is defined.
    @ingroup primitive_number_matchers
 */
#ifdef HC_SHORTHAND
    #define equalToUnsignedInteger HC_equalToUnsignedInteger
#endif
