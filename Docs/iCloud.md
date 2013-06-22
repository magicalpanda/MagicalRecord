
## iCloud Support

  Apps built for iOS5+ and OSX Lion 10.7.2+ can take advantage of iCloud to sync Core Data stores. To implement this functionality with MagicalRecord, use **one** of the following setup calls instead of those listed in the previous section:
  
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)icloudBucket localStoreNamed:(NSString *)localStore;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent;
  	+ (void) setupCoreDataStackWithiCloudContainer:(NSString *)containerID contentNameKey:(NSString *)contentNameKey localStoreNamed:(NSString *)localStoreName cloudStorePathComponent:(NSString *)pathSubcomponent completion:(void(^)(void))completion;
  
For further details, and to ensure that your application is suitable for iCloud, please see [Apple's iCloud Notes](https://developer.apple.com/library/ios/#releasenotes/DataManagement/RN-iCloudCoreData/_index.html).

In particular note that the first helper method, + (void) setupCoreDataStackWithiCloudContainer:(NSString \*)icloudBucket localStoreNamed:(NSString \*)localStore, automatically generates the **NSPersistentStoreUbiquitousContentNameKey** based on your application's Bundle Identifier. 

If you are managing multiple different iCloud stores it is highly recommended that you use one of the other helper methods to specify your own **contentNameKey**
