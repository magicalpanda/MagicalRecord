# Deleting Entities

To delete a single entity in the default context:

```objective-c
// Objective-C
[myPerson MR_deleteEntity];
```

```swift
// Swift
myPerson.mr_deleteEntity()
```


To delete the entity from a specific context:

```objective-c
// Objective-C
[myPerson MR_deleteEntityInContext:otherContext];
```

```swift
// Swift
myPerson.mr_deleteEntity(in: otherContext)
```


To truncate all entities from the default context:

```objective-c
// Objective-C
[Person MR_truncateAll];
```

```swift
// Swift
Person.mr_truncateAll()
```

To truncate all entities in a specific context:

```objective-c
// Objective-C
[Person MR_truncateAllInContext:otherContext];
```

```swift
// Swift
Person.mr_truncateAll(in: otherContext)
```
