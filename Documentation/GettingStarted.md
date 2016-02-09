
# Getting Started

## Setting up the Core Data Stack

To get started, first, import the header file *MagicalRecord.h* in your project's pch file. This will allow a global include of all the required headers.
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
