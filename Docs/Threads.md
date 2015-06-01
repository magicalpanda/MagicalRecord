## Performing Core Data operations on Threads

MagicalRecord also provides some handy methods to set up background context for use with threading. The background saving operations are inspired by the UIView animation block methods, with few minor differences:

* The block in which you add your data saving code will never be on the main thread.
* a single NSManagedObjectContext is provided for your operations.

For example, if we have Person entity, and we need to set the firstName and lastName fields, this is how you would use MagicalRecord to setup a background context for your use:

```objective-c
Person *person; // Retrieve person entity
[MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {

	Person *localPerson = [person MR_inContext:localContext];

	localPerson.firstName = @"John";
	localPerson.lastName = @"Appleseed";

}];
```

In this method, the specified block provides you with the proper context in which to perform your operations, you don't need to worry about setting up the context so that it tells the Default Context that it's done, and should update because changes were performed on another thread.

To perform an action after this save block is completed, you can fill in a completion block:

```objective-c
Person *person; // Retrieve person entity
[MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext){

	Person *localPerson = [person MR_inContext:localContext];

	localPerson.firstName = @"John";
	localPerson.lastName = @"Appleseed";

} completion:^(BOOL success, NSError *error) {

	self.everyoneInTheDepartment = [Person findAll];

}];
```

This completion block is called on the main thread (queue), so this is also safe for triggering UI updates.

### Perform blocks synchronously

If you want to have your code wait until the save block is done, use `[MagicalRecord saveWithBlockAndWait:]`.

## Creating custom contexts

If you need to create a custom context, you can do so by using `[NSManagedObjectContext MR_context];`. This will return a new context of type `NSPrivateQueueConcurrencyType`, with the root saving context as it's parent.

To perform operations on the context's queue, use `[context performBlock:]` or `[context performBlockAndWait:]`.

To save the context, you can use one of the following:

* `[context MR_saveOnlySelfWithCompletion:]` - Save asynchronously to self and it's parent, but not to the persistent store
* `[context MR_saveToPersistentStoreWithCompletion:]` - Save asynchronously all the way down to the persistent store
* `[context MR_saveOnlySelfAndWait]` - Save synchronously to self and it's parent, but not to the persistent store
* `[context MR_saveToPersistentStoreAndWait]` - Save synchronously all the way down to the persistent store

## Debugging Core Data threading-related issues
You can enable core data threading assertions by adding `-com.apple.CoreData.ConcurrencyDebug 1` to your scheme's launch parameters. This will stop your app and open the debugger every time your app tries to do a context operation on the wrong thread. This is very helpful, especially in finding bugs that are rare and hard to reproduce.

More info on this can be found in the "225 - What's New in Core Data" session from WWDC 2014.
