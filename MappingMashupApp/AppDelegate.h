//
//  AppDelegate.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Property for current location coordinate
@property (strong, nonatomic) LocationManager *locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D myCurrentGPSLocation;


@end
