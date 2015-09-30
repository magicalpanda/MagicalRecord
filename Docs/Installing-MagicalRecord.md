# Installing MagicalRecord

**Adding MagicalRecord to your project is simple**: Just choose whichever method you're most comfortable with and follow the instructions below.

## Using Carthage

1. Add the following line to your `Cartfile`:

    ```yaml
    github "MagicalPanda/MagicalRecord"
    ```

2. Run `carthage update` in your project directory.
3. Drag the appropriate `MagicalRecord.framework` for your platform (located in `Carthage/Build/``) into your application’s Xcode project, and add it to the appropriate target(s).


## Using CocoaPods

One of the easiest ways to integrate MagicalRecord in your project is to use [CocoaPods](http://cocoapods.org/):

1. Add the following line to your `Podfile`:

    a. Plain

    ````ruby
    pod "MagicalRecord"
    ````
    b. With CocoaLumberjack as Logger

    ````ruby
    pod "MagicalRecord/CocoaLumberjack"
    ````

2. In your project directory, run `pod update`
3. You should now be able to add `#import <MagicalRecord/MagicalRecord.h>` to any of your target's source files and begin using MagicalRecord!

## Using an Xcode subproject

Xcode sub-projects allow your project to use and build MagicalRecord as an implicit dependency.

1. Add MagicalRecord to your project as a Git submodule:

    ````
    $ cd MyXcodeProjectFolder
    $ git submodule add https://github.com/magicalpanda/MagicalRecord.git Vendor/MagicalRecord
    $ git commit -m "Add MagicalRecord submodule"
    ````

2. Drag `Vendor/MagicalRecord/MagicalRecord.xcproj` into your existing Xcode project
3. Navigate to your project's settings, then select the target you wish to add MagicalRecord to
4. Navigate to **Build Phases** and expand the **Link Binary With Libraries** section
5. Click the **+** and find the version of the MagicalRecord framework appropriate to your target's platform
6. You should now be able to add `#import <MagicalRecord/MagicalRecord.h>` to any of your target's source files and begin using MagicalRecord!

> **Note** Please be aware that if you've set Xcode's **Link Frameworks Automatically** to **No** then you may need to add the CoreData.framework to your project on iOS, as UIKit does not include Core Data by default. On OS X, Cocoa includes Core Data.

# Shorthand Category Methods

By default, all of the category methods that MagicalRecord provides are prefixed with `MR_`. This is inline with [Apple's recommendation not to create unadorned category methods to avoid naming clashes](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html#//apple_ref/doc/uid/TP40011210-CH6-SW4).

If you like, you can include the following headers to use shorter, non-prefixed category methods:

```objective-c
#import <MagicalRecord/MagicalRecord.h>
#import <MagicalRecord/MagicalRecord+ShorthandMethods.h>
#import <MagicalRecord/MagicalRecordShorthandMethodAliases.h>
```

If you're using Swift, you'll need to add these imports to your target's Objective-C bridging header.

Once you've included the headers, you should call the `+[MagicalRecord enableShorthandMethods]` class method _before_ you setup/use MagicalRecord:

```objective-c
- (void)theMethodWhereYouSetupMagicalRecord
{
    [MagicalRecord enableShorthandMethods];

    // Setup MagicalRecord as per usual
}
```

**Please note that we do not offer support for this feature**. If it doesn't work, [please file an issue](https://github.com/magicalpanda/MagicalRecord/issues/new) and we'll fix it when we can.
