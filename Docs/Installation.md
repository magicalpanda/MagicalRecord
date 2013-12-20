# Installation

1. Drag the `MagicalRecord` folder (under the main folder) into your Xcode project;
2. Import the `CoreData+MagicalRecord.h` file in your project/target's pre-compiled header (PCH), or import the header into each class you wish to use it in;
3. Start writing code!

**Note:** By default, all category methods added by MagicalRecord have a prefix of `MR_`. If you'd prefer to use the methods without a prefix (ie. `findAll` in lieu of `MR_findAll`) precede any instances of  `#import "CoreData+MagicalRecord.h"` with `#define MR_SHORTHAND`, like so:

	#define MR_SHORTHAND
	#import "CoreData+MagicalRecord.h"


# Requirements

* iOS SDK 6.x or later; or
* OS X SDK 10.8 or later
* Xcode 5 is required to run the included tests, but the library builds under Xcode 4
