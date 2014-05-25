### Fetching

#### Basic Finding

Most methods in MagicalRecord return an `NSArray` of results.

Say you have an Entity called "Person", related to a Department (as seen in various Apple Core Data documentation). To get all of the Person entities from your Persistent Store, use the following method:

```objective-c
NSArray *people = [Person MR_findAll];
```

Or, to return the results sorted by a property:

```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName" ascending:YES];
```

Or, to return the results sorted by multiple properties:

```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName" ascending:YES];
```

Or, to return the results sorted by multiple properties with different attributes (these will default to whatever you set them to):

```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName:NO,FirstName" ascending:YES];

// OR

NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName:YES" ascending:NO];
```

If you have a unique way of retrieving a single object from your data store (such as via an identifier), you can use the following method:

```objective-c
Person *person = [Person MR_findFirstByAttribute:@"FirstName" withValue:@"Forrest"];
```

#### Advanced Finding

If you want to be more specific with your search, you can send in a predicate:

```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", @[dept1, dept2]];
NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];
```

#### Returning an NSFetchRequest

```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];
NSFetchRequest *people = [Person MR_requestAllWithPredicate:peopleFilter];
```

For each of these single line calls, the full stack of NSFetchRequest, NSSortDescriptors and a simple default error handling scheme (ie. logging to the console) is created.

#### Customizing the Request

```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

NSFetchRequest *peopleRequest = [Person MR_requestAllWithPredicate:peopleFilter];
[peopleRequest setReturnsDistinctResults:NO];
[peopleRequest setReturnPropertiesNamed:@[@"FirstName", @"LastName"]];

NSArray *people = [Person MR_executeFetchRequest:peopleRequest];
```

#### Find the number of entities

You can also perform a count of all entities of a specific type in your Persistent Store:

```objective-c
NSNumber *count = [Person MR_numberOfEntities];
```

Or, if you're looking for a count of entities based on a predicate or some filter:

```objective-c
NSNumber *count = [Person MR_numberOfEntitiesWithPredicate:...];
```

There are also complementary methods which return `NSUInteger` rather than `NSNumber` instances:

* `MR_countOfEntities`
* `MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context`
* `MR_countOfEntitiesWithPredicate:(NSPredicate *)predicate`
* `MR_countOfEntitiesWithPredicate:(NSPredicate *)predicatecontext inContext:(NSManagedObjectContext *)`

#### Aggregate Operations

```objective-c
NSInteger totalFat = [[CTFoodDiaryEntry MR_aggregateOperation:@"sum:" onAttribute:@"fatCalories" withPredicate:predicate] integerValue];
NSInteger fattest  = [[CTFoodDiaryEntry MR_aggregateOperation:@"max:" onAttribute:@"fatCalories" withPredicate:predicate] integerValue];
NSArray *caloriesByMonth = [CTFoodDiaryEntry MR_aggregateOperation:@"sum:" onAttribute:@"fatCalories" withPredicate:predicate groupBy:@"month"];
```

#### Finding from a different context

All find, fetch, and request methods have an inContext: method parameter

```objective-c
NSArray *peopleFromAnotherContext = [Person MR_findAllInContext:someOtherContext];

Person *personFromContext = [Person MR_findFirstByAttribute:@"lastName" withValue:@"Gump" inContext:someOtherContext];

NSUInteger count = [Person MR_numberOfEntitiesWithContext:someOtherContext];
```

## Creating new Entities

When you need to create a new instance of an Entity, use:

```objective-c
Person *myPerson = [Person MR_createEntity];
```

or, to specify which context the entity is inserted into:

```objective-c
Person *myPerson = [Person MR_createEntityInContext:otherContext];
```

## Deleting Entities

To delete a single entity:

```objective-c
[myPerson MR_deleteEntity];
```

or, to delete the entity from a specific context:

```objective-c
[myPerson MR_deleteEntityInContext:otherContext];
```

There is no delete *All Entities* or *truncate* operation in core data, so one is provided for you with Active Record for Core Data:

```objective-c
[Person MR_truncateAll];
```

or, to truncate all entities in a specific context:

```objective-c
[Person MR_truncateAllInContext:otherContext];
```
