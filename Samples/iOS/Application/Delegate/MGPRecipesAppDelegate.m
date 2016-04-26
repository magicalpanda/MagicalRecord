//
//  MGPAppDelegate.m
//  Recipes
//
//  Created by Saul Mora on 5/19/13.
//
//

#import "MGPRecipesAppDelegate.h"
#import "RecipeListTableViewController.h"
#import "UnitConverterTableViewController.h"

static NSString * const kRecipesStoreName = @"Recipes.sqlite";

@interface MGPRecipesAppDelegate ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation MGPRecipesAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self copyDefaultStoreIfNecessary];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    [MagicalRecord setupCoreDataStackWithStoreNamed:kRecipesStoreName];
    
    //init window
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    //init viewControllers
    RecipeListTableViewController *recipeListController = [[RecipeListTableViewController alloc] init];
    UnitConverterTableViewController *unitController = [[UnitConverterTableViewController alloc] init];
    
    UINavigationController *recipesNavigationController = [[UINavigationController alloc] initWithRootViewController:recipeListController];
    UINavigationController *unitNavigationController = [[UINavigationController alloc] initWithRootViewController:unitController];
    self.tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = @[recipesNavigationController,unitNavigationController];
    self.window.rootViewController = _tabBarController;

    // Override point for customization after application launch.
//    self.window.backgroundColor = [UIColor whiteColor];
    recipeListController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    [self.window addSubview:self.tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) copyDefaultStoreIfNecessary;
{
	NSFileManager *fileManager = [NSFileManager defaultManager];

    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kRecipesStoreName];

	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:[storeURL path]])
    {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kRecipesStoreName stringByDeletingPathExtension] ofType:[kRecipesStoreName pathExtension]];
        
		if (defaultStorePath)
        {
            NSError *error;
			BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success)
            {
                NSLog(@"Failed to install default recipe store");
            }
		}
	}

}
@end
