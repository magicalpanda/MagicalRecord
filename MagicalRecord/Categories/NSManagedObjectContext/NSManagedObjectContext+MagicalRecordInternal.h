#import <Foundation/Foundation.h>


@interface NSManagedObjectContext (MagicalRecordInternal)

- (void) MR_mergeChangesFromNotification:(NSNotification *)notification;
- (void) MR_mergeChangesOnMainThread:(NSNotification *)notification;
+ (void) MR_setDefaultContext:(NSManagedObjectContext *)moc;
+ (void) MR_setRootSavingContext:(NSManagedObjectContext *)context;
+ (void)MR_makeContextObtainPermanentIDsBeforeSaving:(NSManagedObjectContext *)context;
+ (void)MR_makeContext:(NSManagedObjectContext *)sourceContext mergeChangesToContext:(NSManagedObjectContext *)targetContext;
@end
