//
//  ViewController.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YelpMapViewController.h"
#import "Annotation.h"
#import "Venue.h"
#import "APIManager.h"
#import "LocationManager.h"
#import "AppDelegate.h"


@interface YelpMapViewController ()
{
    APIManager *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
    LocationManager *mobileMakersLocation;
}
@end

@implementation YelpMapViewController
@synthesize returnedArray;
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    mobileMakersLocation = [[LocationManager alloc] init];
    
    yelpProcess = [[APIManager alloc]initWithYelpSearch:@"food" andLocation:mobileMakersLocation];
    
    yelpProcess.delegate = self;
    
    [yelpProcess getYelpJSON];
}

- (void)grabArray:(NSArray *)data
{
    yelpData = [self createPlacesArray:data];
    [self addPinsToMap];
}

- (NSMutableArray *)createPlacesArray:(NSArray *)placesData
{
    returnedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *placeDictionary in placesData)
    {
        float placeLatitude = [[placeDictionary valueForKey:@"latitude"] floatValue];
        float placeLongitude = [[placeDictionary valueForKey:@"longitude"] floatValue];
        CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:placeLatitude longitude:placeLongitude];
        
        Venue *place = [[Venue alloc] init];
        place.name = [placeDictionary valueForKey:@"name"];
        place.location = placeLocation;
        [returnedArray addObject:place];
    }
    return returnedArray;
}

-(void)addPinsToMap
{
    //make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion myRegion = {mobileMakersLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion];
    
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        NSString *nameOfPlace = [[returnedArray objectAtIndex:i] name];
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        Annotation *myAnnotation = [[Annotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        
        //add to map
        [myMapView addAnnotation:myAnnotation];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
