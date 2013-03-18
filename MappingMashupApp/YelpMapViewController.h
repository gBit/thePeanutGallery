//
//  ViewController.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataSourceDelegate.h"
#import <CoreData/CoreData.h>

@interface YelpMapViewController : UIViewController <DataSourceDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSMutableArray *returnedArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(void)addPinsToMap;

@end
