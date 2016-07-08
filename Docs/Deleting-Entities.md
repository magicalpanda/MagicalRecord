# Deleting Entities

To delete a single entity in the default context:

*Objective-C*:
```objective-c
[myPerson MR_deleteEntity];
```

*Swift*:
```swift
myPerson?.MR_deleteEntity()
```

To delete the entity from a specific context:

*Objective-C*:
```objective-c
[myPerson MR_deleteEntityInContext:otherContext];
```

*Swift*:
```swift
myPerson?.MR_deleteInContext(otherContext)
```

To truncate all entities from the default context:

*Objective-C*:
```objective-c
[Person MR_truncateAll];
```

*Swift*:
```swift
Person.MR_truncateAll()
```

To truncate all entities in a specific context:

*Objective-C*:
```objective-c
[Person MR_truncateAllInContext:otherContext];
```

*Swift*:
```swift
Person.MR_truncateAllInContext(otherContext)
```
