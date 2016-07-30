//
//  AppDelegate.m
//  movie
//
//  Created by Raghu Venkatesh on 08/06/13.
//  Copyright (c) 2013 Raghu Venkatesh. All rights reserved.
//

#import "AppDelegate.h"
#import "PuzzleManager.h"
#import "LocalNotifManager.h"
#import "PuzzleCompleteViewController.h"
#import "Countly.h"
#import <AdColony/AdColony.h>
#import <zlib.h>

@implementation AppDelegate
{
    PuzzleManager * puzzleManager;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    //[[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    //[window addSubview:viewController.view];
    //[window makeKeyAndVisible];
    application.applicationIconBadgeNumber = 0;
    
    //NSString *retrieveuuid = [SSKeychain passwordForService:@"com.bitpanda.2p1m" account:@"user"];
    
    
    //countly stuff
    [[Countly sharedInstance] startOnCloudWithAppKey:@"4e32ecb87efecc579922677f876d562196785af5"];
//    NSString *userKey = [AdColony getCustomID];
//    userKey = [userKey stringByAppendingString:@"::DAU"];
//    [[Countly sharedInstance] recordEvent:userKey count:1];
    //adcolony initialization
    [AdColony configureWithAppID:@"app2ce954115f184016bb"
                         zoneIDs:@[@"vzac26d06223aa4f26a5",@"vzb10c21c4d6874a9982",@"vza00b0503812d423b8a",@"vzfe3ea51386ba404492",@"vz87753e9e98c74f0aa9"]
                        delegate:nil
                         logging:YES];
    
    //UINavigationBar *navBar = [[UIApplication sharedApplication] keyWindow].rootViewController;

//    CGRect frame = [navBar frame];
//    frame.size.height = 32;
//    [navBar setFrame:frame];
    
    // store custom id
    NSString *udid = [AdColony getOpenUDID];
    NSData* data = [udid dataUsingEncoding:NSUTF8StringEncoding];
    unsigned long result = crc32(0, data.bytes, data.length);
    NSString *customId = [NSString stringWithFormat: @"%lu", result];
    [AdColony setCustomID:customId];
    //NSLog(@"CRC32: %lu", result);

    UIImage *navBarImage = [UIImage imageNamed:@"Header.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage
    forBarMetrics:UIBarMetricsDefault];
    //[navBar sizeThatFits:CGSizeMake(320,100000)];

    
    //[[UINavigationBar appearance] setFrame:   CGRectMake(0, 0, 0, 0)];
    // Handle launching from a notification
    
    puzzleManager = [PuzzleManager getInstance];
    //check if all puuzles the are solved if yes display
    if([puzzleManager getLevel]  > [puzzleManager getPuzzleCount])
    {
        
           //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
//                                                                 bundle: nil];
//        PuzzleCompleteViewController *controller = [mainStoryboard instantiateViewControllerWithIdentifier:@"complete"];
          UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"complete"]];
//        self.window.rootViewController = navigationController;
        
        
            self.window.rootViewController = navigationController;
        
        //[self.window setRootViewController:controller];
        //    [self.window addSubview:[navigationController view]];
        //self.window.
        //[self.window makeKeyAndVisible];
        
    }
    else{
    
    UIImage* bgImage;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
        bgImage = [UIImage imageNamed:@"HomePage_BG-568h@2x.png"];
    } else {
        bgImage = [UIImage imageNamed:@"HomePage_BG.png"];
    }
    
    //[window set]
    window.backgroundColor = [UIColor colorWithPatternImage:bgImage];

        UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Recieved Notification %@",localNotif);
    }
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[PuzzleManager getInstance] persistToDisk];
    [LocalNotifManager sendLocalNotif];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [LocalNotifManager  cancelLocalNotif];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"puzzle" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[NSBundle mainBundle]
                       URLForResource: @"puzzle" withExtension:@"sqlite"];
    
    
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return[[NSBundle mainBundle]
           URLForResource: @"puzzle" withExtension:@"sqllite"];
    ;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	return YES;
}

- (void)resetIdleTimer
{
    if (idleTimer) {
        [idleTimer invalidate];
    }
    
    // Schedule a timer to fire in kApplicationTimeoutInMinutes * 60
    int timeout =10;
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(idleTimerExceeded)
                                                userInfo:nil
                                                 repeats:NO];
    
}

- (void)idleTimerExceeded {
    /* Post a notification so anyone who subscribes to it can be notified when
     * the application times out */
    
    [LocalNotifManager sendLocalNotif];
}


@end
