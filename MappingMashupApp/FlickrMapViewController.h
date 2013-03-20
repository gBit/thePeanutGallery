//
//  FlickrMapViewController.h
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/18/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "DataSourceDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface FlickrMapViewController : UIViewController <MKMapViewDelegate, DataSourceDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *missLocationManager;
}

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

//NOT a pre-defined method
-(void) startLocationUpdates;
@end
