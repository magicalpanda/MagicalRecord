# Creating Entities

To create and insert a new instance of an Entity in the default context, you can use:

```objective-c
// Objective-C
Person *myPerson = [Person MR_createEntity];
```

```swift
// Swift
let myPerson = Person.mr_createEntity()
```


To create and insert an entity into specific context:

```objective-c
// Objective-C
Person *myPerson = [Person MR_createEntityInContext:otherContext];
```

```swift
// Swift
let myPerson = Person.mr_createEntity(in: otherContext)
```
