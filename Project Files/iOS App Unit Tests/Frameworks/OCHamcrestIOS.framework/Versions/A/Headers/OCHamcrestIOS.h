//
//  OCHamcrest - OCHamcrest.h
//  Copyright 2011 hamcrest.org. See LICENSE.txt
//
//  Created by: Jon Reid
//

/**
    @defgroup library Matcher Library

    Library of Matcher implementations
 */

/**
    @defgroup core_matchers Core Matchers

    Fundamental matchers of objects and values, and composite matchers

    @ingroup library
 */
#import <OCHamcrestIOS/HCAllOf.h>
#import <OCHamcrestIOS/HCAnyOf.h>
#import <OCHamcrestIOS/HCDescribedAs.h>
#import <OCHamcrestIOS/HCIs.h>
#import <OCHamcrestIOS/HCIsAnything.h>
#import <OCHamcrestIOS/HCIsEqual.h>
#import <OCHamcrestIOS/HCIsInstanceOf.h>
#import <OCHamcrestIOS/HCIsNil.h>
#import <OCHamcrestIOS/HCIsNot.h>
#import <OCHamcrestIOS/HCIsSame.h>

/**
    @defgroup collection_matchers Collection Matchers

    Matchers of collections

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

    Matchers that perform numeric comparisons

    @ingroup library
 */
#import <OCHamcrestIOS/HCIsCloseTo.h>
#import <OCHamcrestIOS/HCOrderingComparison.h>

/**
    @defgroup primitive_number_matchers Primitive Number Matchers

    Matchers for testing equality against primitive numeric types

    @ingroup number_matchers
 */
#import <OCHamcrestIOS/HCIsEqualToNumber.h>

/**
    @defgroup object_matchers Object Matchers

    Matchers that inspect objects

    @ingroup library
 */
#import <OCHamcrestIOS/HCHasDescription.h>

/**
    @defgroup text_matchers Text Matchers

    Matchers that perform text comparisons

    @ingroup library
 */
#import <OCHamcrestIOS/HCIsEqualIgnoringCase.h>
#import <OCHamcrestIOS/HCIsEqualIgnoringWhiteSpace.h>
#import <OCHamcrestIOS/HCStringContains.h>
#import <OCHamcrestIOS/HCStringEndsWith.h>
#import <OCHamcrestIOS/HCStringStartsWith.h>

/**
    @defgroup integration Unit Test Integration
 */
#import <OCHamcrestIOS/HCAssertThat.h>

/**
    @defgroup integration_numeric Unit Tests of Primitive Numbers

    Unit test integration for primitive numbers

    @ingroup integration
 */
#import <OCHamcrestIOS/HCNumberAssert.h>

/**
    @defgroup core Core API
 */

/**
    @defgroup helpers Helpers

    Utilities for writing Matchers

    @ingroup core
 */
