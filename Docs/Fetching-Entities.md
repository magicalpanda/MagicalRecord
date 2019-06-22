# Fetching Entities

#### Basic Finding

Most methods in MagicalRecord return an `NSArray` of results.

As an example, if you have an entity named *Person* related to a *Department* entity (as seen in many of [Apple's Core Data examples](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html)), you can retrieve all of the *Person* entities from your persistent store using the following method:

```objective-c
// Objective-C
NSArray *people = [Person MR_findAll];
```

```swift
// Swift
let people = Person.mr_findAll()
```

To return the same entities sorted by a specific attribute:

```objective-c
// Objective-C
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName"
                                         ascending:YES];
```

```swift
// Swift
let peopleSorted = Person.mr_findAllSorted(by: "LastName", ascending: true)
```

To return the entities sorted by multiple attributes:

```objective-c
// Objective-C
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName"
                                         ascending:YES];
```

```swift
// Swift
let peopleSorted = Person.mr_findAllSorted(by: "LastName,FirstName", ascending: true)
```

To return the results sorted by multiple attributes with different values. If you don't provide a value for any attribute, it will default to whatever you've set in your model:

```objective-c
// Objective-C
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName:NO,FirstName"
                                         ascending:YES];

// OR

NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName:YES"
                                         ascending:NO];
```

```swift
// Swift
let peopleSorted = Person.mr_findAllSorted(by: "LastName:NO,FirstName", ascending: true)

// OR

let peopleSorted = Person.mr_findAllSorted(by: "LastName,FirstName:YES", ascending: false)
```

If you have a unique way of retrieving a single object from your data store (such as an identifier attribute), you can use the following method:

```objective-c
// Objective-C
Person *person = [Person MR_findFirstByAttribute:@"FirstName"
                                       withValue:@"Forrest"];
```

```swift
// Swift
let person = Person.mr_findFirst(byAttribute: "FirstName", withValue: "Forrest")
```

#### Advanced Finding

If you want to be more specific with your search, you can use a predicate:

```objective-c
// Objective-C
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", @[dept1, dept2]];
NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];
```

```swift
// Swift
let peopleFilter = NSPredicate(format: "Department IN %@", [dept1, dept2])
let people = Person.mr_findAll(with: peopleFilter)
```

#### Returning an NSFetchRequest

```objective-c
// Objective-C
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];
NSFetchRequest *people = [Person MR_requestAllWithPredicate:peopleFilter];
```

```swift
// Swift
let peopleFilter = NSPredicate(format: "Department IN %@", departments)
let people = Person.mr_requestAll(with: peopleFilter)
```

For each of these single line calls, an `NSFetchRequest` and `NSSortDescriptor`s for any sorting criteria  are created.

#### Customizing the Request

```objective-c
// Objective-C
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

NSFetchRequest *peopleRequest = [Person MR_requestAllWithPredicate:peopleFilter];
[peopleRequest setReturnsDistinctResults:NO];
[peopleRequest setPropertiesToFetch:@[@"FirstName", @"LastName"]];

NSArray *people = [Person MR_executeFetchRequest:peopleRequest];
```

```swift
// Swift
let peopleFilter = NSPredicate(format: "Department IN %@", departments)

let peopleRequest = Person.mr_requestAll(with: peopleFilter)
peopleRequest.returnsDistinctResults = false
peopleRequest.propertiesToFetch = ["FirstName", "LastName"]

let people = Person.mr_executeFetchRequest(peopleRequest)
```

#### Find excluding subentities

To fetch all sorted, excluding subentities:

```objective-c
// Objective-C
NSFetchRequest *peopleRequest = [Person MR_requestAllSortedBy:@"LastName" ascending:YES withPredicate:nil];
NSFetchedResultsController *controller = [Person MR_fetchController:peopleRequest delegate:nil useFileCache:NO groupedBy:nil inContext:[NSManagedObjectContext MR_defaultContext]];
controller.fetchRequest.includesSubentities = NO;
[Person MR_performFetch:controller];

NSArray *people = controller.fetchedObjects;
```

```swift
// Swift
let peopleRequest = Person.mr_requestAllSorted(by: "LastName", ascending: true, with: nil)
let controller = Person.mr_fetchController(peopleRequest, delegate: nil, useFileCache: false, groupedBy: nil, in: NSManagedObjectContext.mr_default())
controller.fetchRequest.includesSubentities = false
Person.mr_performFetch(controller)

let people = controller.fetchedObjects
```

Note: `MR_defaultContext`/`mr_default()` is for main thread. See `Working-with-Managed-Object-Contexts.md` for other contexts.

#### Find the number of entities

You can also perform a count of all entities of a specific type in your persistent store:

```objective-c
// Objective-C
NSNumber *count = [Person MR_numberOfEntities];
```

```swift
// Swift
let count = Person.mr_numberOfEntities()
```

Or, if you're looking for a count of entities based on a predicate or some filter:

```objective-c
// Objective-C
NSNumber *count = [Person MR_numberOfEntitiesWithPredicate:...];
```

```swift
// Swift
let count = Person.mr_numberOfEntities(with: ...)
```

There are also complementary methods which return `NSUInteger` (`UInt` in Swift) rather than `NSNumber` instances:

```objective-c
// Objective-C
+ (NSUInteger) MR_countOfEntities;
+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter
                                     inContext:(NSManagedObjectContext *)context;
```

```swift
// Swift
open class func mr_countOfEntities() -> UInt
open class func mr_countOfEntities(with context: NSManagedObjectContext) -> UInt
open class func mr_countOfEntities(with searchFilter: NSPredicate?) -> UInt
open class func mr_countOfEntities(with searchFilter: NSPredicate?,
                                   in context: NSManagedObjectContext) -> UInt
```

#### Aggregate Operations

```objective-c
// Objective-C
NSNumber *totalCalories = [CTFoodDiaryEntry MR_aggregateOperation:@"sum:"
                                                      onAttribute:@"calories"
                                                    withPredicate:predicate];

NSNumber *mostCalories  = [CTFoodDiaryEntry MR_aggregateOperation:@"max:"
                                                      onAttribute:@"calories"
                                                    withPredicate:predicate];

NSArray *caloriesByMonth = [CTFoodDiaryEntry MR_aggregateOperation:@"sum:"
                                                       onAttribute:@"calories"
                                                     withPredicate:predicate
                                                           groupBy:@"month"];
```

```swift
// Swift
let totalCalories = CTFoodDiaryEntry.mr_aggregateOperation("sum:",
                                                           onAttribute: "calories",
                                                           with: predicate)

let mostCalories = CTFoodDiaryEntry.mr_aggregateOperation("max:",
                                                          onAttribute: "calories",
                                                          with: predicate)

let caloriesByMonth = CTFoodDiaryEntry.mr_aggregateOperation("sum:",
                                                             onAttribute: "calories",
                                                             with: predicate,
                                                             groupBy: "month")
```

#### Finding entities in a specific context

All find, fetch, and request methods have an `inContext:` method parameter that allows you to specify which managed object context you'd like to query:

```objective-c
// Objective-C
NSArray *peopleFromAnotherContext = [Person MR_findAllInContext:someOtherContext];

Person *personFromContext = [Person MR_findFirstByAttribute:@"lastName"
                                                  withValue:@"Gump"
                                                  inContext:someOtherContext];

NSUInteger count = [Person MR_numberOfEntitiesWithContext:someOtherContext];
```

```swift
// Swift
let peopleFromAnotherContext = Person.mr_findAll(in: someOtherContext)

let personFromContext = Person.mr_findFirst(byAttribute: "lastName",
                                            withValue: "Gump",
                                            in: someOtherContext)

let count = Person.mr_numberOfEntities(with: someOtherContext)
```
