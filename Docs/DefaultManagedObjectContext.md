

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

