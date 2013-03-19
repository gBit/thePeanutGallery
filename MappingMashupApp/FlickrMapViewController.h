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

@interface FlickrMapViewController : UIViewController <MKMapViewDelegate, DataSourceDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
