### Fetching

#### Basic Finding

Most methods in MagicalRecord return an NSArray of results. So, if you have an Entity called Person, related to a Department (as seen in various Apple Core Data documentation), to get all the Person entities from your Persistent Store:

	//In order for this to work you need to add "#define MR_SHORTHAND" to your PCH file
	NSArray *people = [Person findAll];

	// Otherwise you can use the longer, namespaced version
	NSArray *people = [Person MR_findAll];

Or, to have the results sorted by a property:

	NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName" ascending:YES];

Or, to have the results sorted by multiple properties:

        NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName" ascending:YES];

If you have a unique way of retrieving a single object from your data store, you can get that object directly:

	Person *person = [Person MR_findFirstByAttribute:@"FirstName" withValue:@"Forrest"];

#### Advanced Finding

If you want to be more specific with your search, you can send in a predicate:

	NSArray *departments = [NSArray arrayWithObjects:dept1, dept2, ..., nil];
	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];

#### Returning an NSFetchRequest

	NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

	NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];

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