# ActiveRecord Fetching for Core Data

In software engineering, the active record pattern is a design pattern found in software that stores its data in relational databases. It was named by Martin Fowler in his book Patterns of Enterprise Application Architecture. The interface to such an object would include functions such as Insert, Update, and Delete, plus properties that correspond more-or-less directly to the columns in the underlying database table.

>	Active record is an approach to accessing data in a database. A database table or view is wrapped into a class; thus an object 	instance is tied to a single row in the table. After creation of an object, a new row is added to the table upon save. Any object	loaded gets its information from the database; when an object is updated, the corresponding row in the table is also updated. The	wrapper class implements accessor methods or properties for each column in the table or view.

>	*- [Wikipedia]("http://en.wikipedia.org/wiki/Active_record_pattern")*

Active Record for Core Data was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:

* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed

# Installation

- In your XCode Project, add all the .h and .m files into your project. 
- Add the proper import states for the .h files either to your specific files using Core Data, or in your pre-compiled header file
- Start writing code! ... There is no step 3!

# Usage

## Setting up the Core Data Stack

To get started, first, import the header file *CoreData+ActiveRecordFetching.h* in your project's pch file. This will allow a global include of all the required headers.
Next, somewhere in your app's startup, say in the applicationDidFinishLaunching:(UIApplication *) withOptions:(NSDictionary *) method, use one of the following setup calls with the ActiveRecordHelpers class:

	+ (void) setupCoreDataStack;
	+ (void) setupAutoMigratingDefaultCoreDataStack;
	+ (void) setupCoreDataStackWithInMemoryStore;
	+ (void) setupCoreDataStackWithStoreNamed:(NSString *)storeName;
	+ (void) setupCoreDataStackWithAutoMigratingSqliteStoreNamed:(NSString *)storeName;
	
 - or -

Simply start creating, fetching and updating objects. A default stack will be created for you automatically if one does not already exist. It's magical :)

And, before your app exits, you can use the clean up method:

	[ActiveRecordHelpers cleanUp];

### Default Managed Object Context 

When using Core Data, you will deal with two types of objects the most: NSManagedObject and NSManagedObjectContext. ActiveRecord for Core Data gives you a place for a default NSManagedObjectContext for use within your app. This is great for single threaded apps. If you need to create a new Managed Object Context for use in other threads, based on your single persistent store, use:

	NSManagedObjectContext *myNewContext = [NSManagedObjectContext context];


This default context will be used for all fetch requests, unless otherwise specified in the methods ending with **inContext:**.
If you want to make *myNewContext* the default for all fetch requests on the main thread:

	[NSManagedObjectContext setDefaultContext:myNewContext];


This will use the same object model and persistent store, but create an entirely new context for use with threads other than the main thread. 

**It is recommended that the default context is created and set using the main thread**

### Fetching

#### Basic Finding
Most methods in the ActiveRecord for Core Data library return an NSArray of results. So, if you have an Entity called Person, related to a Department (as seen in various Apple Core Data documentation), to get all the Person entities from your Persistent Store:


	NSArray *people = [Person findAll];


Or, to have the results sorted by a property:

	NSArray *peopleSorted = [Person findAllSortedByProperty:@"LastName" ascending:YES];


If you have a unique way of retrieving a single object from your data store, you can get that object directly:

	Person *person = [Person findFirstByAttribute:@"FirstName" withValue:@"Forrest"];

#### Advanced Finding

If you want to be more specific with your search, you can send in a predicate:

	NSArray *departments = [NSArray arrayWithObjects:dept1, dept2, ..., nil];
	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person findAllWithPredicate:peopleFilter];

Returning an NSFetchRequest

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person fetchAllWithPredicate:peopleFilter];

For each of these single line calls, the full stack of NSFetchRequest, NSSortDescriptors and a simple default error handling scheme (ie. logging to the console) is created.

Customizing the Request

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSFetchRequest *peopleRequest = [Person requestAllWithPredicate:peopleFilter];
	[peopleRequest setReturnsDistinctResults:NO];
	[peopleRequest setReturnPropertiesNamed:[NSArray arrayWithObjects:@"FirstName", @"LastName", nil]];
	...

	NSArray *people = [Person executeFetchRequest:peopleRequest];

#### Find the number of entities

You can also perform a count of entities in your Store, that will be performed on the Store

	NSUInteger count = [Person numberOfEntities];

Or, if you're looking for a count of entities based on a predicate or some filter:

	NSUInteger count = [Person numberOfEntitiesWithPredicate:...];

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

The Active Record fetching library is trying to make these steps more reusable with the following methods:

	+ (void) performSaveDataOperationWithBlock:(CoreDataBlock)block;
	+ (void) performSaveDataOperationInBackgroundWithBlock:(CoreDataBlock)block;

CoreDataBlock is typedef'd as:

	typedef void (^CoreDataBlock)(NSManagedObjectContext *);
	
All the boilerplate operations that need to be done when saving are done in these methods. To use this method from the *main thread*:

	Person *person = ...;
	[ARCoreDataAction saveDataInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
		Person *localPerson = [person inContext:localContext];

		localPerson.firstName = @"Chuck";
		localPerson.lastName = @"Smith";
	}];
	
In this method, the CoreDataBlock provides you with the proper context in which to perform your operations, you don't need to worry about setting up the context so that it tells the Default Context that it's done, and should update because changes were performed on another thread.

All ARCoreDataActions have a dedicated GCD queue on which they operate. This means that throughout your app, you only really have 2 threads performing Core Data actions at any one time: one on the main thread, and another on this dedicated GCD queue.
	
# Extra Bits
This Code is released under the MIT License by [Magical Panda Software, LLC.](http://www.magicalpanda.com)
