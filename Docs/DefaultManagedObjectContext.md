### Default Managed Object Context 

When working with Core Data, you will regularly deal with two main objects: `NSManagedObject` and `NSManagedObjectContext`.

MagicalRecord provides a simple class method to retrieve a default `NSManagedObjectContext` that can be used throughout your app. This context operates on the main thread, and is great for simple, single-threaded apps. 

To access the default context, call:

```objective-c
NSManagedObjectContext *defaultContext = [NSManagedObjectContext MR_defaultContext];
```

This context will be used throughout MagicalRecord in any method that uses a context, but does not provde a specific managed object context parameter.

If you need to create a new managed object context for use in non-main threads, use the following method:

```objective-c
NSManagedObjectContext *myNewContext = [NSManagedObjectContext MR_newContext];
```
	
This will create a new managed object context which has the same object model and persistent store as the default context, but is safe for use on another thread. It automatically sets the default context as it's parent context.

If you'd like to make your `myNewContext` instance the default for all fetch requests, use the following class method:

```objective-c
[NSManagedObjectContext MR_setDefaultContext:myNewContext];
```

> **NOTE:** It is *highly* recommended that the default context is created and set on the main thread using a managed object context with a concurrency type of `NSMainQueueConcurrencyType`.

