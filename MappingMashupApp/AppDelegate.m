//
//  AppDelegate.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = managedObjectContext;
@synthesize locationManager, myCurrentGPSLocation;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // what's file manager?
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:@"Model" withExtension:@"momd"];
    NSURL *sqliteURL = [documentsDirectory URLByAppendingPathComponent:@"Model.sqlite"];
    NSError *error;
    
    managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:managedObjectModel];
    
    // if there isn't a data base....
    if ([persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqliteURL options:nil error:&error])
    {
        //create one.
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        //set new database to myPersistentStoreCoordinator
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    }
    
    //Begin working with location services
    locationManager = [[LocationManager alloc] init];
    myCurrentGPSLocation = locationManager.coordinate;
    NSLog(@"This is our coordinate %f", locationManager.coordinate.latitude);
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
