# MagicalRecord for Core Data

In software engineering, the active record pattern is a design pattern found in software that stores its data in relational databases. It was named by Martin Fowler in his book Patterns of Enterprise Application Architecture. The interface to such an object would include functions such as Insert, Update, and Delete, plus properties that correspond more-or-less directly to the columns in the underlying database table.

>	Active record is an approach to accessing data in a database. A database table or view is wrapped into a class; thus an object 	instance is tied to a single row in the table. After creation of an object, a new row is added to the table upon save. Any object	loaded gets its information from the database; when an object is updated, the corresponding row in the table is also updated. The	wrapper class implements accessor methods or properties for each column in the table or view.

>	*- [Wikipedia]("http://en.wikipedia.org/wiki/Active_record_pattern")*

Magical Record for Core Data was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:

* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed

# Installation

1. In your XCode Project, add all the .h and .m files from the *Source* folder into your project. 
2. Add *CoreData+MagicalRecord.h* file to your PCH file or your AppDelegate file.
    * Optionally add `#define MR_SHORTHAND` to your PCH file if you want to use shorthand like `findAll` instead of `MR_findAll`
4. Start writing code! ... There is no step 3!

# ARC Support

MagicalRecord fully supports ARC *and* non-ARC modes out of the box, there is no configuration necessary. This is great for legacy applications or projects that still need to compile with GCC.  ARC support has been tested with the Apple LLVM 3.0 compiler.

# Usage

## Setting up the Core Data Stack

To get started, first, import the header file *CoreData+MagicalRecord.h* in your project's pch file. This will allow a global include of all the required headers.
Next, somewhere in your app delegate, in either the applicationDidFinishLaunching:(UIApplication *) withOptions:(NSDictionary *) method, or awakeFromNib, use **one** of the following setup calls with the MagicalRecordHelpers class:

	+ (void) setupCoreDataStack;
	+ (void) setupAutoMigratingDefaultCoreDataStack;
	+ (void) setupCoreDataStackWithInMemoryStore;
	+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
	+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;

Each call instantiates one of each piece of the Core Data stack, and provides getter and setter methods for these instances. These well known instances to MagicalRecord, and are recognized as "defaults".

And, before your app exits, you can use the clean up method:

	[MagicalRecordHelpers cleanUp];
	
## iCloud Support

  Apps built for iOS5+ and OSX Lion 10.7.2+ can take advantage of iCloud to sync Core Data stores. To implement this functionality with Magical Record, use **one** of the following setup calls instead of those listed in the previous section:
  
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
  
For further details, and to ensure that your application is suitable for iCloud, please see [Apple's iCloud Notes](https://developer.apple.com/library/ios/#releasenotes/DataManagement/RN-iCloudCoreData/_index.html).

In particular note that the first helper method, + (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore, automatically generates the **NSPersistentStoreUbiquitousContentNameKey** based on your application's Bundle Identifier. 

If you are managing multiple different iCloud stores it is highly recommended that you use one of the other helper methods to specify your own **contentNameKey**

### Default Managed Object Context 

When using Core Data, you will deal with two types of objects the most: *NSManagedObject* and *NSManagedObjectContext*. MagicalRecord gives you a place for a default NSManagedObjectContext for use within your app. This is great for single threaded apps. You can easily get to this default context by calling:

    [NSManagedObjectContext MR_defaultContext];

This context will be used if a find or request method (described below) is not specifying a specific context using the **inContext:** method overload.

If you need to create a new Managed Object Context for use in other threads, based on the default persistent store that was creating using one of the setup methods, use:

	NSManagedObjectContext *myNewContext = [NSManagedObjectContext context];
	
This will use the same object model and persistent store, but create an entirely new context for use with threads other than the main thread. 

And, if you want to make *myNewContext* the default for all fetch requests on the main thread:

	[NSManagedObjectContext setDefaultContext:myNewContext];

Magical Record also has a helper method to hold on to a Managed Object Context in a thread's threadDictionary. This lets you access the correct NSManagedObjectContext instance no matter which thread you're calling from. This methods is:

	[NSManagedObjectContext MR_contextForCurrentThread];

**It is *highly* recommended that the default context is created and set using the main thread**

### Fetching

#### Basic Finding

Most methods in MagicalRecord return an NSArray of results. So, if you have an Entity called Person, related to a Department (as seen in various Apple Core Data documentation), to get all the Person entities from your Persistent Store:

	//In order for this to work you need to add "#define MR_SHORTHAND" to your PCH file
	NSArray *people = [Person findAll];

	// Otherwise you can use the longer, namespaced version
	NSArray *people = [Person MR_findAll];

Or, to have the results sorted by a property:

	NSArray *peopleSorted = [Person findAllSortedByProperty:@"LastName" ascending:YES];

Or, to have the results sorted by multiple properties:

    NSArray *peopleSorted = [Person findAllSortedByProperty:@"LastName,FirstName" ascending:YES];

If you have a unique way of retrieving a single object from your data store, you can get that object directly:

	Person *person = [Person findFirstByAttribute:@"FirstName" withValue:@"Forrest"];

#### Advanced Finding

If you want to be more specific with your search, you can send in a predicate:

	NSArray *departments = [NSArray arrayWithObjects:dept1, dept2, ..., nil];
	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person findAllWithPredicate:peopleFilter];

#### Returning an NSFetchRequest

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person fetchAllWithPredicate:peopleFilter];

For each of these single line calls, the full stack of NSFetchRequest, NSSortDescriptors and a simple default error handling scheme (ie. logging to the console) is created.

#### Customizing the Request

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSFetchRequest *peopleRequest = [Person requestAllWithPredicate:peopleFilter];
	[peopleRequest setReturnsDistinctResults:NO];
	[peopleRequest setReturnPropertiesNamed:[NSArray arrayWithObjects:@"FirstName", @"LastName", nil]];
	...

	NSArray *people = [Person executeFetchRequest:peopleRequest];

#### Find the number of entities

You can also perform a count of entities in your Store, that will be performed on the Store

	NSNumber *count = [Person numberOfEntities];

Or, if you're looking for a count of entities based on a predicate or some filter:

	NSNumber *count = [Person numberOfEntitiesWithPredicate:...];
	
There are also counterpart methods which return NSUInteger rather than NSNumbers:

* countOfEntities
* countOfEntitiesWithContext:(NSManagedObjectContext *)
* countOfEntitiesWithPredicate:(NSPredicate *)
* countOfEntitiesWithPredicate:(NSPredicate *) inContext:(NSManagedObjectContext *)

#### Aggregate Operations

    NSPredicate *prediate = [NSPredicate predicateWithFormat:@"diaryEntry.date == %@", today];
    int totalFat = [[CTFoodDiaryEntry aggregateOperation:@"sum:" onAttribute:@"fatColories" withPredicate:predicate] intValue];
    int fattest  = [[CTFoodDiaryEntry aggregateOperation:@"max:" onAttribute:@"fatColories" withPredicate:predicate] intValue];
    
#### Finding from a different context

All find, fetch and request methods have an inContext: method parameter

	NSManagedObjectContext *someOtherContext = ...;

	NSArray *peopleFromAnotherContext = [Person findAllInContext:someOtherContext];

	...

	Person *personFromContext = [Person findFirstByAttribute:@"lastName" withValue:@"Gump" inContext:someOtherContext];

	...

	NSUInteger count = [Person numberOfEntitiesWithContext:someOtherContext];


## Creating new Entities

When you need to create a new instance of an Entity, use:

	Person *myNewPersonInstance = [Person createEntity];

or, to specify a context:

	NSManagedObjectContext *otherContext = ...;

	Person *myPerson = [Person createInContext:otherContext];


## Deleting Entities

To delete a single entity:

	Person *p = ...;
	[p  deleteEntity];

or, to specify a context:

	NSManagedObjectContext *otherContext = ...;
	Person *deleteMe = ...;

	[deleteMe deleteInContext:otherContext];

There is no delete *All Entities* or *truncate* operation in core data, so one is provided for you with Active Record for Core Data:

	[Person truncateAll];

or, with a specific context:

	NSManagedObjectContext *otherContext = ...;
	[Person truncateAllInContext:otherContext];

## Performing Core Data operations on Threads

Available only on iOS 4.0 and Mac OS 10.6

Paraphrasing the [Apple documentation on Core Data and Threading]("http://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdConcurrency.html#//apple_ref/doc/uid/TP40003385-SW1"), you should always do the following:

* Use a new, dedicated NSManagedObjectContext instance for every thread
* Use an instance of your NSManagedObjects that is local for the new NSManagedObjectContext
* Notify other contexts that the background is updated or saved

The Magical Record library is trying to make these steps more reusable with the following methods:

	+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
	+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;

CoreDataBlock is typedef'd as:

	typedef void (^CoreDataBlock)(NSManagedObjectContext *);
	
All the boilerplate operations that need to be done when saving are done in these methods. To use this method from the *main thread*:

	Person *person = ...;
	[MRCoreDataAction saveDataInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
		Person *localPerson = [person inContext:localContext];

		localPerson.firstName = @"Chuck";
		localPerson.lastName = @"Smith";
	}];
	
In this method, the CoreDataBlock provides you with the proper context in which to perform your operations, you don't need to worry about setting up the context so that it tells the Default Context that it's done, and should update because changes were performed on another thread.

To perform an action after this save block is completed, you can fill in a completion block:

	Person *person = ...;
	[MRCoreDataAction saveDataInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
		Person *localPerson = [person inContext:localContext];

		localPerson.firstName = @"Chuck";
		localPerson.lastName = @"Smith";
	} completion:^{
	
		self.everyoneInTheDepartment = [Person findAll];
	}];
	
This completion block is called on the main thread (queue), so this is also safe for triggering UI updates.	

All MRCoreDataActions have a dedicated GCD queue on which they operate. This means that throughout your app, you only really have 2 queues (sort of like threads) performing Core Data actions at any one time: one on the main queue, and another on this dedicated GCD queue.

# Data Import

*Experimental*

MagicalRecord will now import data from NSDictionaries into your Core Data store. [Documentation](https://github.com/magicalpanda/MagicalRecord/wiki/Data-Import) for this feature will be added to the wiki.
This feature is currently under development, and is undergoing updates. Feel free to try it out, add tests and send in your feedback.
	
# Extra Bits
This Code is released under the MIT License by [Magical Panda Software, LLC.](http://www.magicalpanda.com)
