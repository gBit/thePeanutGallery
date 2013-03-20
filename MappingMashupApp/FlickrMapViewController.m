//
//  FlickrMapViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/18/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "FlickrMapViewController.h"
#import "YelpMapViewController.h"
#import "YelpWebPageBrowser.h"
#import "AppDelegate.h"
#import "LocationManager.h"
#import "APIManager.h"
#import "Venue.h"
#import "Annotation.h"
#import "Photo.h"
#import "Business.h"

@interface FlickrMapViewController ()
{
    LocationManager *locationManager;
    Annotation *selectedAnnotation;
    //NSMutableArray *venuesArray;
    
    __weak IBOutlet MKMapView *mapView;
}

@end

@implementation FlickrMapViewController
@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //God help us, please make the location services work! Puh_LEASE JESUS
    [self startLocationUpdates];
    
    //Edit by ross: 3.19.13 - add navigation button to Bookmarks viewController (not implemented yet)
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkButtonPressed)];
    //Created method "bookmarkButtonPressed, currently has no action - End edit
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Location Services
    locationManager = appDelegate.locationManager;
    [mapView setShowsUserLocation:YES];
    
    APIManager *yelpAPIManager = [[APIManager alloc] initWithYelpSearch:@"free%20wifi" andLocation:missLocationManager];
    yelpAPIManager.delegate = self;
     
    // Allocate objects
    // [possibly allocate the venuesArray later?]
   
    [yelpAPIManager searchYelpParseResults];
    
    //NSLog(@"----- venues array --------%@", venuesArray);
    
    //[self addPinsToMap];
    
   }



# pragma mark - User Location Methods
// deprecated: fix later
-(void)locationManager:(CLLocationManager*)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    //how many seconds ago was this new location created
    //NSTimeInterval time = [[newLocation timestamp] timeIntervalSinceNow];
    
    //CLLocation manager will return last found location
    //if this location was made more than 3 minutes ago, ignore
//    if (time<-180) {
//        return;
//    }
    //NSLog(@"%@", [newLocation description]);

    //[self foundLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //Code goes here, but it won't error quite yet, so HA.
}

-(void) startLocationUpdates
{
    if(missLocationManager == nil)
        {
            missLocationManager = [[CLLocationManager alloc]init];
        }
    missLocationManager.delegate = self;
    [missLocationManager startUpdatingLocation];
}

-(void)mapView:(MKMapView *)userMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = userLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    [userMapView setRegion:region animated:YES];
}

# pragma mark - Annotation Methods
-(void)foundLocation:(CLLocation*)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    //create an instances of annotation with the current data
    Annotation *annotation = [[Annotation alloc]initWithCoordinate:coord
                                                             title:@"title"
                                                          subtitle:@"Somebody does not want poop"
                                                           yelpURL:@"http://www.catstache.biz"];
    //add annotation to mapview
    [mapView addAnnotation:annotation];
    
    //zoom to region of location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    [mapView setRegion:region animated:YES];
    
    [locationManager stopUpdatingLocation];
}

- (void)addPinsToMap:(NSMutableArray*)parsedArray;
{
    NSMutableArray *venuesArray = parsedArray;
    
    NSLog(@"%@", [[parsedArray objectAtIndex:0] valueForKey:@"latitude"]);
    
    APIManager *flickrAPIManager = [[APIManager alloc] initWithFlickrSearch:@"color" andVenue:[parsedArray objectAtIndex:0]];
    
    [flickrAPIManager searchFlickrParseResults];
    
    NSLog(@"latitude from venue: %@", [[parsedArray objectAtIndex:0] valueForKey:@"latitude"]);
    
    NSLog(@"------------%@----------", flickrAPIManager);
    
    
    // make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion region = {missLocationManager.location.coordinate, span};
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
        
        
        
//        myAnnotation.title = venueName;
//        myAnnotation.subtitle = @"Demo subtitle";
        
        NSLog(@"%@", venuesArray);
        //Add code here to capture yelp page URL
        NSString *yelpURLString = [[venuesArray objectAtIndex:i] valueForKey:@"yelpURL"];
//        myAnnotation.yelpPageURL = yelpURLString;
        
        //
        // REVISE TO LEVERAGE NEW CUSTOM INITS //
        //
        // create annotation
         //Annotation *myAnnotation = [[Annotation alloc] initWithPosition:venueCoordinate];
        Annotation *myAnnotation = [[Annotation alloc] initWithCoordinate:venueCoordinate title:venueName subtitle:@"Demo Subtite" yelpURL:yelpURLString];

        
        //add to map
        [mapView addAnnotation:myAnnotation];
        
        
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
    //if you place an invalid image name - the annotation will be blank
    //good for yelp results while testing
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
    YelpMapViewController *ymvc = [segue destinationViewController];
    // what's getting passed in
}

//
// Method for unwind action
//
-(IBAction) backToFlickrMapView: (UIStoryboardSegue *)segue
{
	//Any additional actions to be performed during unwind
}

-(void) bookmarkButtonPressed
{
    NSLog(@"User pressed button to go to bookmarks");
}

# pragma  mark - End of document

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end