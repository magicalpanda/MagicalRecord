#import "EXPMatchers+beCloseTo.h"
#import "EXPMatcherHelpers.h"

EXPMatcherImplementationBegin(_beCloseToWithin, (id expected, id within)) {
  prerequisite(^BOOL{
    return [actual isKindOfClass:[NSNumber class]] &&
		[expected isKindOfClass:[NSNumber class]] &&
		([within isKindOfClass:[NSNumber class]] || (within == nil));
  });

  match(^BOOL{
		double actualValue = [actual doubleValue];
		double expectedValue = [expected doubleValue];

		if (within != nil) {
			double withinValue = [within doubleValue];
			double lowerBound = expectedValue - withinValue;
			double upperBound = expectedValue + withinValue;
			return (actualValue >= lowerBound) && (actualValue <= upperBound);
		} else {
			double diff = fabs(actualValue - expectedValue);
			actualValue = fabs(actualValue);
			expectedValue = fabs(expectedValue);
			double largest = (expectedValue > actualValue) ? expectedValue : actualValue;
			return (diff <= largest * FLT_EPSILON);
		}
  });

  failureMessageForTo(^NSString *{
    return [NSString stringWithFormat:
            (within ? @"expected %@ to be close to %@ within %@"
                    : @"expected %@ to be close to %@"),
            EXPDescribeObject(actual), EXPDescribeObject(expected), EXPDescribeObject(within)];
  });

  failureMessageForNotTo(^NSString *{
    return [NSString stringWithFormat:
            (within ? @"expected %@ not to be close to %@ within %@"
                    : @"expected %@ not to be close to %@"),
            EXPDescribeObject(actual), EXPDescribeObject(expected), EXPDescribeObject(within)];
  });
}
EXPMatcherImplementationEnd