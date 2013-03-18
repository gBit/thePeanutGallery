//
//  FlickrMapViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/18/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "FlickrMapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YelpMapViewController.h"
#import "Annotation.h"
#import "Venue.h"
#import "APIManager.h"
#import "LocationManager.h"
#import "AppDelegate.h"
#import "YelpWebPageBrowser.h"
#import "Photo.h"
#import "Business.h"

@interface FlickrMapViewController ()
{
    APIManager *yelpProcess;
    NSMutableArray *yelpData;
    LocationManager *currentLocation;
    Annotation * selectedAnnotation;
    __weak IBOutlet MKMapView *myMapView;
}

@end

@implementation FlickrMapViewController
@synthesize returnedArray, managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //COREDATA
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    //*COREDATA
    
    //Commenting this out 11:32 AM
//    currentLocation = [[LocationManager alloc] init];
    CLLocationCoordinate2D myCurrentLocation = appDelegate.myCurrentGPSLocation;
    NSLog(@"Kick children, but only if they're here: %f", myCurrentLocation.latitude);
    //Set current location (currently static)
//    CLLocationCoordinate2D mmCoordinate =
//    {
//        .latitude = myCurrentLocation.latitude,
//        .longitude = myCurrentLocation.longitude
//    };
    
    MKCoordinateSpan defaultSpan =
    {
        .latitudeDelta = 0.02f,
        .longitudeDelta = 0.02f
    };
    
    MKCoordinateRegion myRegion = {myCurrentLocation, defaultSpan};
//    MKCoordinateRegion secondRegion = MKCoordinateRegionMake(myCurrentLocation, defaultSpan);
//    MKUserLocation *myCurrentLocation = [[MKUserLocation alloc] init];
    
    //[myMapView addAnnotation:myCurrentLocation];
    
    [myMapView setRegion:myRegion animated:YES];
//    [self UpdateMapViewWithNewCenter:myCurrentLocation];
    
    //End ross' changes
    
    
    yelpProcess = [[APIManager alloc]initWithYelpSearch:@"free%20wifi" andLocation:appDelegate.locationManager];
    
    yelpProcess.delegate = self;
    
    [yelpProcess getYelpJSON];
    [self UpdateMapViewWithNewCenter:myCurrentLocation];

    
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
        place.yelpURL= [placeDictionary valueForKey:@"url"];
        
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
    
    MKCoordinateRegion myRegion = {currentLocation.coordinate, span};
    //set region to mapview
    [myMapView setRegion:myRegion animated:YES];
    
    
    for (int i = 0; i < returnedArray.count; i++)
    {
        CLLocation *locationOfPlace = [[returnedArray objectAtIndex:i] location];
        NSString *nameOfPlace = [[returnedArray objectAtIndex:i] name];
        //        NSString *addressOfPlace = [[returnedArray objectAtIndex:i] addres];
        
        //coordinate make
        CLLocationCoordinate2D placeCoordinate;
        placeCoordinate.longitude = locationOfPlace.coordinate.longitude;
        placeCoordinate.latitude = locationOfPlace.coordinate.latitude;
        
        //annotation make
        Annotation *myAnnotation = [[Annotation alloc] initWithPosition:&placeCoordinate];
        myAnnotation.title = nameOfPlace;
        myAnnotation.subtitle = @"Demo subtitle";
        
        NSLog(@"%@", returnedArray);
        //Add code here to capture yelp page URL
        NSString *yelpURLString = [[returnedArray objectAtIndex:i] valueForKey:@"yelpURL"];
        NSLog(@"%@", yelpURLString);
        myAnnotation.yelpPageURL = yelpURLString;
        
        //add to map
        [myMapView addAnnotation:myAnnotation];
        
        
    }
    NSLog(@"%@", [[myMapView.annotations objectAtIndex:0] title]);
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

- (void)UpdateMapViewWithNewCenter: (CLLocationCoordinate2D)newCoordinate
{
    
    MKCoordinateRegion newRegion = {newCoordinate, myMapView.region.span};
    
    [myMapView setRegion:newRegion];
    
    
}

//User taps on disclosure button to see more Yelp data.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"This is the method we want!");
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"m.yelp.com"]];
    [self performSegueWithIdentifier:@"toYelpWebPage" sender:nil];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YelpWebPageBrowser * ywpb = [segue destinationViewController];
    ywpb.yelpURLString = selectedAnnotation.yelpPageURL;
}

//This method gets called when you select an annotation
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

//Method for unwind action
-(IBAction) backToYelpMapView: (UIStoryboardSegue *)segue
{
	//Any additional actions to be performed during unwind
}

# pragma  mark -- End of document

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end