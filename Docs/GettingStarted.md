
# Getting Started

## Setting up the Core Data Stack

To get started, first, import the header file *CoreData+MagicalRecord.h* in your project's pch file. This will allow a global include of all the required headers.
Next, somewhere in your app delegate, in either the applicationDidFinishLaunching:(UIApplication \*) withOptions:(NSDictionary \*) method, or awakeFromNib, use **one** of the following setup calls with the **MagicalRecord** class:

	+ (void) setupCoreDataStack;
	+ (void) setupAutoMigratingDefaultCoreDataStack;
	+ (void) setupCoreDataStackWithInMemoryStore;
	+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
	+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

Each call instantiates one of each piece of the Core Data stack, and provides getter and setter methods for these instances. These well known instances to MagicalRecord, and are recognized as "defaults".

When using the default sqlite data store with the DEBUG flag set, if you change your model without creating a new model version, Magical Record will delete the old store and create a new one automatically. No more uninstall/reinstall every time you make a change!

And finally, before your app exits, you can use the clean up method:

	[MagicalRecord cleanUp];
	

## Nested Contexts

New in Core Data is support for related contexts. This is a super neat, and super fast feature. However, writing a wrapper that supports both is, frankly, more work that it's worth. However, the 1.8.3 version will be the last version that has dual support, and going forward, MagicalRecord will only work with the version of Core Data that supports nested managed object contexts.

MagicalRecord provides a background saving queue so that saving all data is performed off the main thread, in the background. This means that it may be necessary to use *MR_saveNestedContexts* rather than the typical *MR_save* method in order to persist your changes all the way to your persistent store;

