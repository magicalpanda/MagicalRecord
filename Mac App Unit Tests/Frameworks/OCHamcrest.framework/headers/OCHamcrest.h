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
#import <OCHamcrest/HCAllOf.h>
#import <OCHamcrest/HCAnyOf.h>
#import <OCHamcrest/HCDescribedAs.h>
#import <OCHamcrest/HCIs.h>
#import <OCHamcrest/HCIsAnything.h>
#import <OCHamcrest/HCIsEqual.h>
#import <OCHamcrest/HCIsInstanceOf.h>
#import <OCHamcrest/HCIsNil.h>
#import <OCHamcrest/HCIsNot.h>
#import <OCHamcrest/HCIsSame.h>

/**
    @defgroup collection_matchers Collection Matchers

    Matchers of collections

    @ingroup library
 */
#import <OCHamcrest/HCHasCount.h>
#import <OCHamcrest/HCIsCollectionContaining.h>
#import <OCHamcrest/HCIsCollectionContainingInAnyOrder.h>
#import <OCHamcrest/HCIsCollectionContainingInOrder.h>
#import <OCHamcrest/HCIsCollectionOnlyContaining.h>
#import <OCHamcrest/HCIsDictionaryContaining.h>
#import <OCHamcrest/HCIsDictionaryContainingEntries.h>
#import <OCHamcrest/HCIsDictionaryContainingKey.h>
#import <OCHamcrest/HCIsDictionaryContainingValue.h>
#import <OCHamcrest/HCIsEmptyCollection.h>
#import <OCHamcrest/HCIsIn.h>

/**
    @defgroup number_matchers Number Matchers

    Matchers that perform numeric comparisons

    @ingroup library
 */
#import <OCHamcrest/HCIsCloseTo.h>
#import <OCHamcrest/HCOrderingComparison.h>

/**
    @defgroup primitive_number_matchers Primitive Number Matchers

    Matchers for testing equality against primitive numeric types

    @ingroup number_matchers
 */
#import <OCHamcrest/HCIsEqualToNumber.h>

/**
    @defgroup object_matchers Object Matchers

    Matchers that inspect objects

    @ingroup library
 */
#import <OCHamcrest/HCHasDescription.h>

/**
    @defgroup text_matchers Text Matchers

    Matchers that perform text comparisons

    @ingroup library
 */
#import <OCHamcrest/HCIsEqualIgnoringCase.h>
#import <OCHamcrest/HCIsEqualIgnoringWhiteSpace.h>
#import <OCHamcrest/HCStringContains.h>
#import <OCHamcrest/HCStringEndsWith.h>
#import <OCHamcrest/HCStringStartsWith.h>

/**
    @defgroup integration Unit Test Integration
 */
#import <OCHamcrest/HCAssertThat.h>

/**
    @defgroup integration_numeric Unit Tests of Primitive Numbers

    Unit test integration for primitive numbers

    @ingroup integration
 */
#import <OCHamcrest/HCNumberAssert.h>

/**
    @defgroup core Core API
 */

/**
    @defgroup helpers Helpers

    Utilities for writing Matchers

    @ingroup core
 */
