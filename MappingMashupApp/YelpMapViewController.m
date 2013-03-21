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
   // NSMutableArray *venuesArray;
    NSMutableArray *photosArray;
    
    __weak IBOutlet MKMapView *yelpMapView;
}

-(void)addPinsToMap;
@end

@implementation YelpMapViewController
@synthesize managedObjectContext, originPhotoLatitude, originPhotoLongitude, originPhotoTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Location Services
    //locationManager = appDelegate.locationManager;
    [yelpMapView setShowsUserLocation:YES];
    
    APIManager *yelpAPIManager = [[APIManager alloc] initWithYelpSearch:@"free%20wifi" andLocation:locationManager];
    yelpAPIManager.delegate = self;
    
    // Allocate objects
    // [possibly allocate the venuesArray later?]
        //Commented line 63 our 3.21.13
    //venuesArray = [[NSMutableArray alloc]init];
    //
    //This view controller SUCCESSFULLY imports the starting lat/long from the Flickr view controller.
    //VenuesArray is nil here (empty pointer)
    //Yelp API manager didn't kick us out of this class to APIManager.m
    //Need to verify that this Yelp search (with no Flickr results) is using the passed lat/long.
    //If you go to this VC by tapping a disclosure button from previous one, it will crash.
    //Segue does work, data makes it over, THEN it crashes
    //Crash appears to confirm on "didreceiveYelpData
    //We end up at lat/long 0/0 when this runs, so look into location services problems
    //
    //Need to make the below a new, separate Yelp search that does NOT touch Flickr anything.
    //
    
    //Set map region to the imported lat/long
    CLLocationCoordinate2D originLocationCoordinate =
    {
        .latitude = originPhotoLatitude,
        .longitude = originPhotoLongitude
    };
    
    MKCoordinateSpan originSpan =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion originRegion = {originLocationCoordinate, originSpan};
    Annotation *originAnnotation = [[Annotation alloc] initWithCoordinate:originLocationCoordinate title:originPhotoTitle subtitle:@"originPhoto" urlString:@""];
    
     [yelpMapView setRegion:originRegion animated:YES];
     [yelpMapView addAnnotation:originAnnotation];
    
    
    [yelpAPIManager searchYelpForDelegates];
    
    //[self addPinsToMap];
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
-(void) didReceiveYelpData:(NSMutableArray *)venuesArray
{
     [self addPinsToMap:venuesArray];

}

# pragma mark - Annotation Methods
-(void)foundLocation:(CLLocation*)loc
{
    CLLocationCoordinate2D coord = [loc coordinate];
    
    //zoom to region of location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    [yelpMapView setRegion:region animated:YES];
    
    [locationManager stopUpdatingLocation];
}

- (void)addPinsToMap:(NSMutableArray*)venuesArray;
{
    // make region our area
//    MKCoordinateSpan span =
//    {
//        .latitudeDelta = 0.01810686f,
//        .longitudeDelta = 0.01810686f
//    };
//    
//    MKCoordinateRegion region = {locationManager.coordinate, span};
    //set region to mapview
    //[mapView setRegion:region animated:YES];
    
    for (int i = 0; i < 4; i++)
    {
        //CLLocation *venueLocation = [[venuesArray objectAtIndex:i] location];
        NSString *venueName = [[venuesArray objectAtIndex:i] name];
        
        //coordinate make
        
        float annotationLatitude =[[[venuesArray objectAtIndex:i] valueForKey:@"latitude"] floatValue];
        float annotationLongitude =[[[venuesArray objectAtIndex:i] valueForKey:@"longitude"] floatValue];
        
        NSNumber *latitude = [[venuesArray objectAtIndex:i] valueForKey:@"latitude"];
        NSNumber *longitude = [[venuesArray objectAtIndex:i] valueForKey:@"longitude"];
        
        
        CLLocationCoordinate2D venueCoordinate = {annotationLatitude, annotationLongitude};
        
        NSString *urlString = [[venuesArray objectAtIndex:i] valueForKey:@"urlString"];

        Annotation *myAnnotation = [[Annotation alloc] initWithCoordinate:venueCoordinate title:venueName subtitle:@"Demo Subtite" urlString:urlString];
        myAnnotation.longitude = longitude;
        myAnnotation.latitude = latitude;
        myAnnotation.name = [[venuesArray objectAtIndex:i] valueForKey:@"name"];
        myAnnotation.viewDate = [NSDate date];
        myAnnotation.yelpURLString = urlString;
        
        
        //add to map
        [yelpMapView addAnnotation:myAnnotation];
    }
    
    
//    for (int i = 0; i < venuesArray.count; i++)
//    {
//        CLLocation *venueLocation = [[venuesArray objectAtIndex:i] location];
//        NSString *venueName = [[venuesArray objectAtIndex:i] name];
//        
//        //coordinate make
//        CLLocationCoordinate2D venueCoordinate;
//        venueCoordinate.longitude = venueLocation.coordinate.longitude;
//        venueCoordinate.latitude = venueLocation.coordinate.latitude;
//        
//        //
//        // REVISE TO LEVERAGE NEW CUSTOM INITS //
//        //
//        // create annotation
//        // Annotation *myAnnotation = [[Annotation alloc] initWithPosition:placeCoordinate];
//        // myAnnotation.title = nameOfPlace;
//        // myAnnotation.subtitle = @"Demo subtitle";
//        
//        //NSLog(@"%@", returnedArray);
//        //Add code here to capture yelp page URL
//        //NSString *yelpURLString = [[returnedArray objectAtIndex:i] valueForKey:@"yelpURL"];
//        //NSLog(@"%@", yelpURLString);
//        //myAnnotation.yelpPageURL = yelpURLString;
//        
//        //add to map
//        //[myMapView addAnnotation:myAnnotation];
//        
//        
//    }
    //NSLog(@"%@", [[myMapView.annotations objectAtIndex:0] title]);
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    
    //Code for specifically dealing with the origin photo
    if ([[annotation subtitle] isEqual: @"originPhoto"])
    {
        return nil;
    }
    
    //    [detailButton addTarget:self
    //                     action:@selector(goToYelpPage)
    //           forControlEvents:UIControlEventTouchUpInside];
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"wifiIcon.png"];
    //annotationView.image = selectedannotation.thumbnail;
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
    
    Business *selectedBusiness = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:managedObjectContext];
    
    selectedBusiness.latitude = selectedAnnotation.latitude;
    selectedBusiness.longitude = selectedAnnotation.longitude;
    selectedBusiness.name = selectedAnnotation.name;
    selectedBusiness.yelpURLString = selectedAnnotation.yelpURLString;
    selectedBusiness.viewDate = selectedAnnotation.viewDate;
    
    
        NSError *error;
        if (![managedObjectContext save:&error])
        {
            NSLog(@"failed to save: %@", [error userInfo]);
        }
    
    
//    @property (nonatomic, retain) NSNumber * latitude;
//    @property (nonatomic, retain) NSNumber * longitude;
//    @property (nonatomic, retain) NSString * name;
//    @property (nonatomic, retain) NSString * phone;
//    @property (nonatomic, retain) NSNumber * isBookmarked;
//    @property (nonatomic, retain) NSDate * viewDate;
//    @property (nonatomic, retain) NSString * yelpURLString;
//    @property (nonatomic, retain) NSSet *photo;
    
    //Note: This should break when we switch from Yelp annotations
    //to Flickr photos.
    //Once it doees work, delete this comment
//    Business *selectedBusiness = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:managedObjectContext];
//    
//    selectedBusiness.name = view.annotation.title;
//    
//    NSError *error;
//    if (![managedObjectContext save:&error])
//    {
//        NSLog(@"failed to save: %@", [error userInfo]);
//    }
    
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
    ywpb.yelpURLString = selectedAnnotation.yelpURLString;
    
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
