# Creating Entities

To create and insert a new instance of an Entity in the default context, you can use:

*Objective-C*:
```objective-c
Person *myPerson = [Person MR_createEntity];
```

*Swift*:
```swift
let myPerson = Person.MR_createEntity()
```

To create and insert an entity into specific context:

*Objective-C*:
```objective-c
Person *myPerson = [Person MR_createEntityInContext:otherContext];
```

*Swift*:
```swift
let myPerson = Person.MR_createInContext(otherContext)
```
