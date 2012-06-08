//
//  OCHamcrest - OCHamcrest.h
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

/**
    @defgroup library Matcher Library

    Library of Matcher implementations.
 */

/**
    @defgroup object_matchers Object Matchers

    Matchers that inspect objects.

    @ingroup library
 */
#import <OCHamcrestIOS/HCConformsToProtocol.h>
#import <OCHamcrestIOS/HCHasDescription.h>
#import <OCHamcrestIOS/HCHasProperty.h>
#import <OCHamcrestIOS/HCIsEqual.h>
#import <OCHamcrestIOS/HCIsInstanceOf.h>
#import <OCHamcrestIOS/HCIsNil.h>
#import <OCHamcrestIOS/HCIsSame.h>

/**
    @defgroup collection_matchers Collection Matchers

    Matchers of collections.

    @ingroup library
 */
#import <OCHamcrestIOS/HCHasCount.h>
#import <OCHamcrestIOS/HCIsCollectionContaining.h>
#import <OCHamcrestIOS/HCIsCollectionContainingInAnyOrder.h>
#import <OCHamcrestIOS/HCIsCollectionContainingInOrder.h>
#import <OCHamcrestIOS/HCIsCollectionOnlyContaining.h>
#import <OCHamcrestIOS/HCIsDictionaryContaining.h>
#import <OCHamcrestIOS/HCIsDictionaryContainingEntries.h>
#import <OCHamcrestIOS/HCIsDictionaryContainingKey.h>
#import <OCHamcrestIOS/HCIsDictionaryContainingValue.h>
#import <OCHamcrestIOS/HCIsEmptyCollection.h>
#import <OCHamcrestIOS/HCIsIn.h>

/**
    @defgroup number_matchers Number Matchers

    Matchers that perform numeric comparisons.

    @ingroup library
 */
#import <OCHamcrestIOS/HCIsCloseTo.h>
#import <OCHamcrestIOS/HCOrderingComparison.h>

/**
    @defgroup primitive_number_matchers Primitive Number Matchers

    Matchers for testing equality against primitive numeric types.

    @ingroup number_matchers
 */
#import <OCHamcrestIOS/HCIsEqualToNumber.h>

/**
    @defgroup text_matchers Text Matchers

    Matchers that perform text comparisons.

    @ingroup library
 */
#import <OCHamcrestIOS/HCIsEqualIgnoringCase.h>
#import <OCHamcrestIOS/HCIsEqualIgnoringWhiteSpace.h>
#import <OCHamcrestIOS/HCStringContains.h>
#import <OCHamcrestIOS/HCStringContainsInOrder.h>
#import <OCHamcrestIOS/HCStringEndsWith.h>
#import <OCHamcrestIOS/HCStringStartsWith.h>

/**
    @defgroup logical_matchers Logical Matchers

    Boolean logic using other matchers.

    @ingroup library
 */
#import <OCHamcrestIOS/HCAllOf.h>
#import <OCHamcrestIOS/HCAnyOf.h>
#import <OCHamcrestIOS/HCIsAnything.h>
#import <OCHamcrestIOS/HCIsNot.h>

/**
    @defgroup decorator_matchers Decorator Matchers

    Matchers that decorate other matchers for better expression.

    @ingroup library
 */
#import <OCHamcrestIOS/HCDescribedAs.h>
#import <OCHamcrestIOS/HCIs.h>

/**
    @defgroup integration Unit Test Integration
 */
#import <OCHamcrestIOS/HCAssertThat.h>

/**
    @defgroup integration_numeric Unit Tests of Primitive Numbers

    Unit test integration for primitive numbers.
    
    The @c assertThat&lt;Type&gt; macros convert the primitive actual value to an @c NSNumber,
    passing that to the matcher for evaluation. If the matcher is not satisfied, an exception is
    thrown describing the mismatch.

    This family of macros is designed to integrate well with OCUnit and other unit testing
    frameworks. Unmet assertions are reported as test failures. In Xcode, they can be clicked to
    reveal the line of the assertion.

    @ingroup integration
 */
#import <OCHamcrestIOS/HCNumberAssert.h>

/**
    @defgroup core Core API
 */

/**
    @defgroup helpers Helpers

    Utilities for writing Matchers.

    @ingroup core
 */
