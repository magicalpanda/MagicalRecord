# Fetching Entities

#### Basic Finding

Most methods in MagicalRecord return an `NSArray` of results.

As an example, if you have an entity named *Person* related to a *Department* entity (as seen in many of [Apple's Core Data examples](.com/library/mac/documentation/Cocoa/Conceptual/CoreData/Articles/cdBasics.html#//apple_ref/doc/uid/TP40001650-TP1)), you can retrieve all of the *Person* entities from your persistent store using the following method:

*Objective-C*:
```objective-c
NSArray *people = [Person MR_findAll];
```

*Swift*:
```swift
let people = Person.MR_findAll()
```

To return the same entities sorted by a specific attribute:

*Objective-C*:
```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName"
                                         ascending:YES];
```

*Swift*:
```swift
let peopleSorted = Person.MR_findAllSortedBy("LastName", ascending: true)
```

To return the entities sorted by multiple attributes:

*Objective-C*:
```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName"
                                         ascending:YES];
```

*Swift*:
```swift
let peopleSorted = Person.MR_findAllSortedBy("LastName,FirstName", ascending: true)
```

To return the results sorted by multiple attributes with different values. If you don't provide a value for any attribute, it will default to whatever you've set in your model:

*Objective-C*:
```objective-c
NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName:NO,FirstName"
                                         ascending:YES];

// OR

NSArray *peopleSorted = [Person MR_findAllSortedBy:@"LastName,FirstName:YES"
                                         ascending:NO];
```

*Swift*:
```swift
let peopleSorted = Person.MR_findAllSortedBy("LastName:NO,FirstName", ascending: true)

// OR

let peopleSorted = Person.MR_findAllSortedBy("LastName,FirstName:YES", ascending: false)
```

If you have a unique way of retrieving a single object from your data store (such as an identifier attribute), you can use the following method:

*Objective-C*:
```objective-c
Person *person = [Person MR_findFirstByAttribute:@"FirstName"
                                       withValue:@"Forrest"];
```

*Swift*:
```swift
let person = Person.MR_findFirstByAttribute("FirstName", withValue: "Forrest")
```

#### Advanced Finding

If you want to be more specific with your search, you can use a predicate:

*Objective-C*:
```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", @[dept1, dept2]];
NSArray *people = [Person MR_findAllWithPredicate:peopleFilter];
```

*Swift*:
```swift
let peopleFilter = NSPredicate(format: "Department in %@", [dept1, dept2])
let people = Person.MR_findAllWithPredicate(peopleFilter)
```

#### Returning an NSFetchRequest

*Objective-C*:
```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];
NSFetchRequest *people = [Person MR_requestAllWithPredicate:peopleFilter];
```

*Swift*:
```swift
let peopleFilter = NSPredicate(format: "Department in %@", departments)
let people = Person.MR_requestAllWithPredicate(peopleFilter)
```

For each of these single line calls, an `NSFetchRequest` and `NSSortDescriptor`s for any sorting criteria  are created.

#### Customizing the Request

*Objective-C*:
```objective-c
NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"Department IN %@", departments];

NSFetchRequest *peopleRequest = [Person MR_requestAllWithPredicate:peopleFilter];
[peopleRequest setReturnsDistinctResults:NO];
[peopleRequest setReturnPropertiesNamed:@[@"FirstName", @"LastName"]];

NSArray *people = [Person MR_executeFetchRequest:peopleRequest];
```

*Swift*:
```swift
let peopleFilter = NSPredicate(format: "Department in %@", departments)

let peopleRequest = Person.MR_requestAllWithPredicate(peopleFilter)
peopleRequest.returnsDistinctResults = false
peopleRequest.returnPropertiesNamed = ["FirstName", "LastName"]

let people Person.MR_executeFetchRequest(peopleRequest)
```

#### Find the number of entities

You can also perform a count of all entities of a specific type in your persistent store:

*Objective-C*:
```objective-c
NSNumber *count = [Person MR_numberOfEntities];
```

*Swift*:
```swift
let count = Person.MR_numberOfEntities()
```

Or, if you're looking for a count of entities based on a predicate or some filter:

*Objective-C*:
```objective-c
NSNumber *count = [Person MR_numberOfEntitiesWithPredicate:...];
```

*Swift*:
```swift
let count = Person.MR_numberOfEntitiesWithPredicate(...)
```

There are also complementary methods which return `NSUInteger` rather than `NSNumber` instances:

*Objective-C*:
```objective-c
+ (NSUInteger) MR_countOfEntities;
+ (NSUInteger) MR_countOfEntitiesWithContext:(NSManagedObjectContext *)context;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter;
+ (NSUInteger) MR_countOfEntitiesWithPredicate:(NSPredicate *)searchFilter
                                     inContext:(NSManagedObjectContext *)context;
```

*Swift*:
```swift
func MR_countOfEntities() -> UInt
func MR_countOfEntitiesWithContext(context: NSManagedObjectContext) -> UInt
func MR_countOfEntitiesWithPredicate(searchFilter: NSPredicate?) -> UInt
func MR_countOfEntitiesWithPredicate(searchFilter: NSPredicate?, inContext: NSManagedObjectContext) -> UInt
```

#### Aggregate Operations

*Objective-C*:
```objective-c
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

*Swift*:
```swift
let totalCalories = CTFoodDiaryEntry.MR_aggregateOperation("sum:", onAttribute: "calories", withPredicate: predicate)
let mostCalories = CTFoodDiaryEntry.MR_aggregateOperation("max:", onAttribute: "calories", withPredicate: predicate)
let caloriesByMonth = CTFoodDiaryEntry.MR_aggregateOperation("sum:", onAttribute: "calories", withPredicate: predicate, groupBy: "month")
```

#### Finding entities in a specific context

All find, fetch, and request methods have an `inContext:` method parameter that allows you to specify which managed object context you'd like to query:

*Objective-C*:
```objective-c
NSArray *peopleFromAnotherContext = [Person MR_findAllInContext:someOtherContext];

Person *personFromContext = [Person MR_findFirstByAttribute:@"lastName"
                                                  withValue:@"Gump"
                                                  inContext:someOtherContext];

NSUInteger count = [Person MR_numberOfEntitiesWithContext:someOtherContext];
```

*Swift*:
```swift
let peopleFromAnotherContext = Person.MR_findAllInContext(someOtherContext)
let personFromContext = Person.MR_findFirstByAttribute("lastName", withValue: "Gump", inContext: someOtherContext)
let count = Person.MR_numberOfEntitiesWithContext(someOtherContext)
```
