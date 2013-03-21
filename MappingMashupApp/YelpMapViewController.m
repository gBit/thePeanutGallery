//
//  YelpMapViewController.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//


//
// NEED TO UPDATE DATA POPULATION
// CURRENTLY BASED ON USER LOCATION AND API CALL
// SHOULD TAKE IN OBJECTS FROM FLICKRMAPVIEWCONTROLLER
//
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "YelpMapViewController.h"
#import "YelpWebPageBrowser.h"
#import "AppDelegate.h"

#import "LocationManager.h"
#import "APIManager.h"
#import "Venue.h"
#import "Annotation.h"
#import "Photo.h"
#import "Business.h"

@interface YelpMapViewController ()
{
    LocationManager *locationManager;
    Annotation *selectedAnnotation;
    NSMutableArray *venuesArray;
    NSMutableArray *photosArray;
    
    __weak IBOutlet MKMapView *mapView;
}

-(void)addPinsToMap;
@end

@implementation YelpMapViewController
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Location Services
    //locationManager = appDelegate.locationManager;
    [mapView setShowsUserLocation:YES];
    
    APIManager *yelpAPIManager = [[APIManager alloc] initWithYelpSearch:@"free%20wifi" andLocation:locationManager];
    yelpAPIManager.delegate = self;
    
    // Allocate objects
    // [possibly allocate the venuesArray later?]
    venuesArray = [[NSMutableArray alloc]init];
    [yelpAPIManager searchYelpThenFlickrForDelegates];
    
    [self addPinsToMap];
}

# pragma mark - User Location Methods
// deprecated: fix later

/*
-(void)locationManager:(CLLocationManager*)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    //how many seconds ago was this new location created
    NSTimeInterval time = [[newLocation timestamp] timeIntervalSinceNow];
    
    //CLLocation manager will return last found location
    //if this location was made more than 3 minutes ago, ignore
    if (time<-180) {
        return;
    }
    [self foundLocation:newLocation];
}



-(void)mapView:(MKMapView *)userMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    [userMapView setRegion:region animated:YES];
}
*/


# pragma mark - Annotation Methods
-(void)foundLocation:(CLLocation*)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    //create an instances of annotation with the current data
//    Annotation *annotation = [[Annotation alloc]initWithCoordinate:coord
//                                                             title:@"title"
//                                                          subtitle:@"Somebody does not want poop"
//                                                           yelpURL:@"http://www.catstache.biz"];
    //add annotation to mapview
//    [mapView addAnnotation:annotation];
    
    //zoom to region of location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    [mapView setRegion:region animated:YES];
    
    [locationManager stopUpdatingLocation];
}

-(void)addPinsToMap
{
    // make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion region = {locationManager.coordinate, span};
    //set region to mapview
    [mapView setRegion:region animated:YES];
    
    for (int i = 0; i < venuesArray.count; i++)
    {
        CLLocation *venueLocation = [[venuesArray objectAtIndex:i] location];
        NSString *venueName = [[venuesArray objectAtIndex:i] name];
        
        //coordinate make
        CLLocationCoordinate2D venueCoordinate;
        venueCoordinate.longitude = venueLocation.coordinate.longitude;
        venueCoordinate.latitude = venueLocation.coordinate.latitude;
        
        //
        // REVISE TO LEVERAGE NEW CUSTOM INITS //
        //
        // create annotation
        // Annotation *myAnnotation = [[Annotation alloc] initWithPosition:placeCoordinate];
        // myAnnotation.title = nameOfPlace;
        // myAnnotation.subtitle = @"Demo subtitle";
        
        //NSLog(@"%@", returnedArray);
        //Add code here to capture yelp page URL
        //NSString *yelpURLString = [[returnedArray objectAtIndex:i] valueForKey:@"yelpURL"];
        //NSLog(@"%@", yelpURLString);
        //myAnnotation.yelpPageURL = yelpURLString;
        
        //add to map
        //[myMapView addAnnotation:myAnnotation];
        
        
    }
    //NSLog(@"%@", [[myMapView.annotations objectAtIndex:0] title]);
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    
    //    [detailButton addTarget:self
    //                     action:@selector(goToYelpPage)
    //           forControlEvents:UIControlEventTouchUpInside];
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"wifiIcon.png"];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    if([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    
    return annotationView;
}

# pragma mark - User Actions
//
// User selects an annotation
//
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    selectedAnnotation = view.annotation;
    
    //Note: This should break when we switch from Yelp annotations
    //to Flickr photos.
    //Once it doees work, delete this comment
    Business *selectedBusiness = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:managedObjectContext];
    
    selectedBusiness.name = view.annotation.title;
    
    NSError *error;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"failed to save: %@", [error userInfo]);
    }
    
    //NSLog(@"Logging out the annotation %@", view.annotation.title);
}

//
// User taps on disclosure button to see more Yelp data.
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"This is the method we want!");
    // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"m.yelp.com"]];
    [self performSegueWithIdentifier:@"toYelpWebPage" sender:nil];
    
}

# pragma mark - Transitions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YelpWebPageBrowser * ywpb = [segue destinationViewController];
    //Future Ross, this might break
    //ywpb.yelpURLString = selectedAnnotation.yelpPageURL;
    
}

//
// Method for unwind action
//
-(IBAction) backToYelpMapView: (UIStoryboardSegue *)segue
{
	//Any additional actions to be performed during unwind
}

# pragma  mark - End of document

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
