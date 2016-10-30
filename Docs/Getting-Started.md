To get started, import the `MagicalRecord.h` header file in your project's pch file. This will allow a global include of all the required headers.

If you're using CocoaPods or MagicalRecord.framework, your import should look like:

```objective-c
// Objective-C
#import <MagicalRecord/MagicalRecord.h>
```

```swift
// Swift
import MagicalRecord
```

Otherwise, if you've added MagicalRecord's source files directly to your Objective-C project, your import should be:

```objective-c
#import "MagicalRecord.h"
```

Next, somewhere in your app delegate, in either the `- applicationDidFinishLaunching: withOptions:` method, or `-awakeFromNib`, use **one** of the following setup calls with the **MagicalRecord** class:

```objective-c
// Objective-C
+ (void)setupCoreDataStack;
+ (void)setupAutoMigratingCoreDataStack;
+ (void)setupCoreDataStackWithInMemoryStore;
+ (void)setupCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void)setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;
+ (void)setupCoreDataStackWithStoreAtURL:(NSURL *)storeURL;
+ (void)setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:(NSURL *)storeURL;
```

```swift
// Swift
open class func setupCoreDataStack()
open class func setupCoreDataStackWithInMemoryStore()
open class func setupAutoMigratingCoreDataStack()
open class func setupCoreDataStack(withStoreNamed storeName: String)
open class func setupCoreDataStack(withAutoMigratingSqliteStoreNamed storeName: String)
open class func setupCoreDataStackWithStore(at storeURL: URL)
open class func setupCoreDataStackWithAutoMigratingSqliteStore(at storeURL: URL)
```

Each call instantiates one of each piece of the Core Data stack, and provides getter and setter methods for these instances. These well known instances to MagicalRecord, and are recognized as "defaults".

When using the default SQLite data store with the `DEBUG` flag set, changing your model without creating a new model version will cause MagicalRecord to delete the old store and create a new one automatically. This can be a huge time saver — no more needing to uninstall and reinstall your app every time you make a change your data model! **Please be sure not to ship your app with `DEBUG` enabled: Deleting your app's data without telling the user about it is really bad form!**

Before your app exits, you should call `+cleanUp` class method:

```objective-c
// Objective-C
[MagicalRecord cleanUp];
```

```swift
// Swift
MagicalRecord.cleanUp()
```

This tidies up after MagicalRecord, tearing down our custom error handling and setting all of the Core Data stack created by MagicalRecord to nil.

## iCloud-enabled Persistent Stores

To take advantage of Apple's iCloud Core Data syncing, use **one** of the following setup methods in place of the standard methods listed in the previous section:

```objective-c
// Objective-C
+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                              localStoreNamed:(NSString *)localStore;

+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                               contentNameKey:(NSString *)contentNameKey
                              localStoreNamed:(NSString *)localStoreName
                      cloudStorePathComponent:(NSString *)pathSubcomponent;

+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                               contentNameKey:(NSString *)contentNameKey
                              localStoreNamed:(NSString *)localStoreName
                      cloudStorePathComponent:(NSString *)pathSubcomponent
                                   completion:(void (^)(void))completion;

+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                              localStoreAtURL:(NSURL *)storeURL;

+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                               contentNameKey:(NSString *)contentNameKey
                              localStoreAtURL:(NSURL *)storeURL
                      cloudStorePathComponent:(NSString *)pathSubcomponent;

+ (void)setupCoreDataStackWithiCloudContainer:(NSString *)containerID
                               contentNameKey:(NSString *)contentNameKey
                              localStoreAtURL:(NSURL *)storeURL
                      cloudStorePathComponent:(NSString *)pathSubcomponent
                                   completion:(void (^)(void))completion;
```

```swift
// Swift
open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      localStoreNamed localStore: String)


open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      contentNameKey: String?,
                                                      localStoreNamed localStoreName: String,
                                                      cloudStorePathComponent pathSubcomponent: String?)


open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      contentNameKey: String?,
                                                      localStoreNamed localStoreName: String,
                                                      cloudStorePathComponent pathSubcomponent: String?,
                                                      completion: (() -> Swift.Void)? = nil)


open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      localStoreAt storeURL: URL)


open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      contentNameKey: String?,
                                                      localStoreAt storeURL: URL,
                                                      cloudStorePathComponent pathSubcomponent: String?)


open class func setupCoreDataStackWithiCloudContainer(_ containerID: String,
                                                      contentNameKey: String?,
                                                      localStoreAt storeURL: URL,
                                                      cloudStorePathComponent pathSubcomponent: String?,
                                                      completion: (() -> Swift.Void)? = nil)
```

For further details, please refer to [Apple's "iCloud Programming Guide for Core Data"](https://developer.apple.com/library/archive/documentation/DataManagement/Conceptual/UsingCoreDataWithiCloudPG/Introduction/Introduction.html).


### Notes

If you are managing multiple iCloud-enabled stores, we recommended that you use one of the longer setup methods that allows you to specify your own **contentNameKey**. The shorter setup methods automatically generate the **NSPersistentStoreUbiquitousContentNameKey** based on your app's bundle identifier (`CFBundleIdentifier`):
