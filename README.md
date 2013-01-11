# ![Awesome](https://github.com/magicalpanda/magicalpanda.github.com/blob/master/images/awesome_logo_small.png?raw=true) MagicalRecord

In software engineering, the active record pattern is a design pattern found in software that stores its data in relational databases. It was named by Martin Fowler in his book Patterns of Enterprise Application Architecture. The interface to such an object would include functions such as Insert, Update, and Delete, plus properties that correspond more-or-less directly to the columns in the underlying database table.

>	Active record is an approach to accessing data in a database. A database table or view is wrapped into a class; thus an object instance is tied to a single row in the table. After creation of an object, a new row is added to the table upon save. Any object loaded gets its information from the database; when an object is updated, the corresponding row in the table is also updated. The	wrapper class implements accessor methods or properties for each column in the table or view.

>	*- [Wikipedia]("http://en.wikipedia.org/wiki/Active_record_pattern")*

MagicalRecord was inspired by the ease of Ruby on Rails' Active Record fetching. The goals of this code are:

* Clean up my Core Data related code
* Allow for clear, simple, one-line fetches
* Still allow the modification of the NSFetchRequest when request optimizations are needed


# Installation

1. In your XCode Project, drag the *MagicalRecord* folder (under the main folder) into your project. 
2. Add *CoreData+MagicalRecord.h* file to your PCH file or your AppDelegate file.
3. Optionally preceed the *CoreData+MagicalRecord.h* import with `#define MR_SHORTHAND` to your PCH file if you want to use MagicalRecord methods without the *MR_prefix* like `findAll` instead of `MR_findAll`
4. Start writing code!

# Requirements

MagicalRecord Platform Requirements:

* iOS5.x or newer, or Mac OS 10.7 and newer
* ARC

An iOS4 compatible version is available for use. Reference [tag 1.8.3](https://github.com/magicalpanda/MagicalRecord/tree/1.8.3).

## Updating to 2.1

MagicalRecord 2.1 is considered a major update as there are class and API changes that may affect existing uses of MagicalRecord in your code. 

### Changes to saving

The APIs for saving have been revised to behave more consistently, and also to follow naming patterns present in Core Data. Extensive work has gone into adding automated tests that ensure the save methods (both new and deprecated) continue to work as expected through future updates. 

`MR_save` has been temporarily restored to it's original state of running synchronously on the current thread, and saving to the persistent store. However, the __`MR_save` method is marked as deprecated and will be removed in the next major release of MagicalRecord (version 3.0)__. You should use `MR_saveToPersistentStoreAndWait` if you want the same behaviour in future versions of the library.

### New Methods
The following methods have been added:

#### NSManagedObjectContext+MagicalSaves
- `- (void) MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;`
- `- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;`
- `- (void) MR_saveOnlySelfAndWait;`
- `- (void) MR_saveToPersistentStoreAndWait;`
- `- (void) MR_saveWithOptions:(MRSaveContextOptions)mask completion:(MRSaveCompletionHandler)completion;`

#### __MagicalRecord+Actions__
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;`
- `+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;`
- `+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;`

### Deprecations

The following methods have been deprecated in favour of newer alternatives, and will be removed in MagicalRecord 3.0:

#### NSManagedObjectContext+MagicalSaves
- `- (void) MR_save;`
- `- (void) MR_saveWithErrorCallback:(void(^)(NSError *error))errorCallback;`
- `- (void) MR_saveInBackgroundCompletion:(void (^)(void))completion;`
- `- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback;`
- `- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;`
- `- (void) MR_saveNestedContexts;`
- `- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback;`
- `- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;`
        
### MagicalRecord+Actions
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion;`
- `+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler;`


## ARC Support

MagicalRecord fully supports ARC out of the box, there is no configuration necessary. 
The last version to support manually managed memory is 1.8.3, and is available from the downloads page, or by switching to the 1.8.3 tag in the source.


# Notes
## Third Party Blog Entries
The following blog entries highlight how to install and use aspects of Magical Record.

* [How to make Programming with Core Data Pleasant](http://yannickloriot.com/2012/03/magicalrecord-how-to-make-programming-with-core-data-pleasant/)
* [Using Core Data with MagicalRecord](http://ablfx.com/blog/2012/03/using-coredata-magicalrecord/)
* [Super Happy Easy Fetching in Core Data](http://www.cimgf.com/2011/03/13/super-happy-easy-fetching-in-core-data/)
* [Core Data and Threads, without the Headache](http://www.cimgf.com/2011/05/04/core-data-and-threads-without-the-headache/)
* [Unit Testing with Core Data](http://www.cimgf.com/2012/05/15/unit-testing-with-core-data/)

## Twitter 
Follow [@MagicalRecord](http://twitter.com/magicalrecord) on twitter to stay up to date on twitter with the lastest updates to MagicalRecord and for basic support


## Nested Contexts

New in Core Data is support for related contexts. This is a super neat, and super fast feature. However, writing a wrapper that supports both is, frankly, more work that it's worth. However, the 1.8.3 version will be the last version that has dual support, and going forward, MagicalRecord will only work with the version of Core Data that supports nested managed object contexts.

MagicalRecord provides a background saving queue so that saving all data is performed off the main thread, in the background. This means that it may be necessary to use *MR_saveNestedContexts* rather than the typical *MR_save* method in order to persist your changes all the way to your persistent store;

## Logging
MagicalRecord has logging built in to every fetch request and other Core Data operation. When errors occur when fetching or saving data, these errors are captured by MagicalRecord. By default, these logs use NSLog to present logging information. However, if you have CocoaLumberjack installed in your project, MagicalRecord will use CocoaLumberjack and it's configuration to send logs to their proper output.

All logging in MagicalRecord can be disabled by placing this define preprocessor statement prior to the main import of CoreData+MagicalRecord.h

    #define MR_ENABLE_ACTIVE_RECORD_LOGGING 0

# Usage

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
	
## iCloud Support

  Apps built for iOS5+ and OSX Lion 10.7.2+ can take advantage of iCloud to sync Core Data stores. To implement this functionality with MagicalRecord, use **one** of the following setup calls instead of those listed in the previous section:
  
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
  
For further details, and to ensure that your application is suitable for iCloud, please see [Apple's iCloud Notes](https://developer.apple.com/library/ios/#releasenotes/DataManagement/RN-iCloudCoreData/_index.html).

In particular note that the first helper method, + (void) setupCoreDataStackWithiCloudContainer:(NSString \*)icloudBucket localStoreNamed:(NSString \*)localStore, automatically generates the **NSPersistentStoreUbiquitousContentNameKey** based on your application's Bundle Identifier. 

If you are managing multiple different iCloud stores it is highly recommended that you use one of the other helper methods to specify your own **contentNameKey**

### Default Managed Object Context 

When using Core Data, you will deal with two types of objects the most: *NSManagedObject* and *NSManagedObjectContext*. MagicalRecord provides a single place for a default NSManagedObjectContext for use within your app. This is great for single threaded apps. You can easily get to this default context by calling:

    [NSManagedObjectContext MR_defaultContext];

This context will be used if a find or request method (described below) does not specify a specific context using the **inContext:** method overload.

If you need to create a new Managed Object Context for use in other threads, based on the default persistent store that was creating using one of the setup methods, use:

	NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_context];
	
This will use the same object model and persistent store, but create an entirely new context for use with threads other than the main thread. 

And, if you want to make *myNewContext* the default for all fetch requests on the main thread:

	[NSManagedObjectContext MR_setDefaultContext:myNewContext];

MagicalRecord also has a helper method to hold on to a Managed Object Context in a thread's threadDictionary. This lets you access the correct NSManagedObjectContext instance no matter which thread you're calling from. This methods is:

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

	NSArray *peopleSorted = [Person MR_findAllSortedByProperty:@"LastName" ascending:YES];

Or, to have the results sorted by multiple properties:

    NSArray *peopleSorted = [Person MR_findAllSortedByProperty:@"LastName,FirstName" ascending:YES];

If you have a unique way of retrieving a single object from your data store, you can get that object directly:

	Person *person = [Person MR_findFirstByAttribute:@"FirstName" withValue:@"Forrest"];

#### Advanced Finding

If you want to be more specific with your search, you can send in a predicate:

	NSArray *departments = [NSArray arrayWithObjects:dept1, dept2, ..., nil];
	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];

#### Returning an NSFetchRequest

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person MR_fetchAllWithPredicate:peopleFilter];

For each of these single line calls, the full stack of NSFetchRequest, NSSortDescriptors and a simple default error handling scheme (ie. logging to the console) is created.

#### Customizing the Request

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSFetchRequest *peopleRequest = [Person MR_requestAllWithPredicate:peopleFilter];
	[peopleRequest setReturnsDistinctResults:NO];
	[peopleRequest setReturnPropertiesNamed:[NSArray arrayWithObjects:@"FirstName", @"LastName", nil]];
	...

	NSArray *people = [Person MR_executeFetchRequest:peopleRequest];

#### Find the number of entities

You can also perform a count of entities in your Store, that will be performed on the Store

	NSNumber *count = [Person MR_numberOfEntities];

Or, if you're looking for a count of entities based on a predicate or some filter:

	NSNumber *count = [Person MR_numberOfEntitiesWithPredicate:...];
	
There are also counterpart methods which return NSUInteger rather than NSNumbers:

* countOfEntities
* countOfEntitiesWithContext:(NSManagedObjectContext *)
* countOfEntitiesWithPredicate:(NSPredicate *)
* countOfEntitiesWithPredicate:(NSPredicate *) inContext:(NSManagedObjectContext *)

#### Aggregate Operations

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"diaryEntry.date == %@", today];
    int totalFat = [[CTFoodDiaryEntry MR_aggregateOperation:@"sum:" onAttribute:@"fatColories" withPredicate:predicate] intValue];
    int fattest  = [[CTFoodDiaryEntry MR_aggregateOperation:@"max:" onAttribute:@"fatColories" withPredicate:predicate] intValue];
    
#### Finding from a different context

All find, fetch, and request methods have an inContext: method parameter

	NSManagedObjectContext *someOtherContext = ...;

	NSArray *peopleFromAnotherContext = [Person MR_findAllInContext:someOtherContext];

	...

	Person *personFromContext = [Person MR_findFirstByAttribute:@"lastName" withValue:@"Gump" inContext:someOtherContext];

	...

	NSUInteger count = [Person MR_numberOfEntitiesWithContext:someOtherContext];


## Creating new Entities

When you need to create a new instance of an Entity, use:

	Person *myNewPersonInstance = [Person MR_createEntity];

or, to specify a context:

	NSManagedObjectContext *otherContext = ...;

	Person *myPerson = [Person MR_createInContext:otherContext];


## Deleting Entities

To delete a single entity:

	Person *p = ...;
	[p  MR_deleteEntity];

or, to specify a context:

	NSManagedObjectContext *otherContext = ...;
	Person *deleteMe = ...;

	[deleteMe MR_deleteInContext:otherContext];

There is no delete *All Entities* or *truncate* operation in core data, so one is provided for you with Active Record for Core Data:

	[Person MR_truncateAll];

or, with a specific context:

	NSManagedObjectContext *otherContext = ...;
	[Person MR_truncateAllInContext:otherContext];

## Performing Core Data operations on Threads

MagicalRecord also provides some handy methods to set up background context for use with threading. The background saving operations are inspired by the UIView animation block methods, with few minor differences:

* The block in which you add your data saving code will never be on the main thread.
* a single NSManagedObjectContext is provided for your operations. 

For example, if we have Person entity, and we need to set the firstName and lastName fields, this is how you would use MagicalRecord to setup a background context for your use:

	Person *person = ...;
	[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
	
		Person *localPerson = [person MR_inContext:localContext];

		localPerson.firstName = @"John";
		localPerson.lastName = @"Appleseed";
		
	}];
	
In this method, the specified block provides you with the proper context in which to perform your operations, you don't need to worry about setting up the context so that it tells the Default Context that it's done, and should update because changes were performed on another thread.

To perform an action after this save block is completed, you can fill in a completion block:

	Person *person = ...;
	[MagicalRecord saveInBackgroundWithBlock:^(NSManagedObjectContext *localContext){
	
		Person *localPerson = [person MR_inContext:localContext];

		localPerson.firstName = @"John";
		localPerson.lastName = @"Appleseed";
		
	} completion:^{
	
		self.everyoneInTheDepartment = [Person findAll];
		
	}];
	
This completion block is called on the main thread (queue), so this is also safe for triggering UI updates.	

# Data Import

MagicalRecord will now import data from NSObjects into your Core Data store. [Documentation](https://github.com/magicalpanda/MagicalRecord/wiki/Data-Import) for this feature is forthcoming.
	
# Extra Bits
This Code is released under the MIT License by [Magical Panda Software, LLC](http://www.magicalpanda.com).  We love working on iOS and Mac apps for you!
There is no charge for Awesome.
