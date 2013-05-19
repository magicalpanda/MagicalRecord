### Changes to saving

The APIs for saving have been revised to behave more consistently, and also to follow naming patterns present in Core Data. Extensive work has gone into adding automated tests that ensure the save methods (both new and deprecated) continue to work as expected through future updates. 

`MR_save` has been temporarily restored to it's original state of running synchronously on the current thread, and saving to the persistent store. However, the __`MR_save` method is marked as deprecated and will be removed in the next major release of MagicalRecord (version 3.0)__. You should use `MR_saveToPersistentStoreAndWait` if you want the same behaviour in future versions of the library.

### New Methods
The following methods have been added:

#### NSManagedObjectContext+MagicalSaves
- `- (void) MR_saveOnlySelfWithCompletion:(MRSaveCompletionHandler)completion;`
- `- (void) MR_saveToPersistentStoreWithCompletion:(MRSaveCompletionHandler)completion;`
- `- (void) MR_saveOnlySelfAndWait;`
- `- (void) MR_saveToPersistentStoreAndWait;`
- `- (void) MR_saveWithOptions:(MRSaveContextOptions)mask completion:(MRSaveCompletionHandler)completion;`

#### __MagicalRecord+Actions__
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;`
- `+ (void) saveWithBlockAndWait:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(MRSaveCompletionHandler)completion;`
- `+ (void) saveUsingCurrentThreadContextWithBlockAndWait:(void (^)(NSManagedObjectContext *localContext))block;`

### Deprecations

The following methods have been deprecated in favour of newer alternatives, and will be removed in MagicalRecord 3.0:

#### NSManagedObjectContext+MagicalSaves
- `- (void) MR_save;`
- `- (void) MR_saveWithErrorCallback:(void(^)(NSError *error))errorCallback;`
- `- (void) MR_saveInBackgroundCompletion:(void (^)(void))completion;`
- `- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback;`
- `- (void) MR_saveInBackgroundErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;`
- `- (void) MR_saveNestedContexts;`
- `- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback;`
- `- (void) MR_saveNestedContextsErrorHandler:(void (^)(NSError *error))errorCallback completion:(void (^)(void))completion;`
        
### MagicalRecord+Actions
- `+ (void) saveWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block;`
- `+ (void) saveInBackgroundWithBlock:(void(^)(NSManagedObjectContext *localContext))block completion:(void(^)(void))completion;`
- `+ (void) saveInBackgroundUsingCurrentContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(void (^)(void))completion errorHandler:(void (^)(NSError *error))errorHandler;`


