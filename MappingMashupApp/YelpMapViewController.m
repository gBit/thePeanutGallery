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
#import "YelpWebPageBrowser.h"
#import "Photo.h"
#import "Business.h"


@interface YelpMapViewController ()
{
    APIManager *yelpProcess;
    __weak IBOutlet MKMapView *myMapView;
    NSMutableArray *yelpData;
    LocationManager *mobileMakersLocation;
    Annotation * selectedAnnotation;
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
    
    //Ross' changes 3.17.13
    CLLocationCoordinate2D mmCoordinate =
    {
        .latitude = 41.894032f,
        .longitude = -87.634742f
    };

    MKCoordinateSpan defaultSpan =
    {
        .latitudeDelta = 0.02f,
        .longitudeDelta = 0.02f
    };
    
    MKCoordinateRegion myRegion = {mmCoordinate, defaultSpan};
    MKUserLocation *myCurrentLocation = [[Annotation alloc] init];
    //    myCurrentLocation.annotationType = @"currentLocation";
    //    myCurrentLocation.title = @"You are here.";
    //    myCurrentLocation.coordinate = mmCoordinate;
    
    [myMapView addAnnotation:myCurrentLocation];
    
    
    [myMapView setRegion:myRegion animated:YES];
    
    //End ross' changes
    
    
    yelpProcess = [[APIManager alloc]initWithYelpSearch:@"free%20wifi" andLocation:mobileMakersLocation];
    
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
    
    MKCoordinateRegion myRegion = {mobileMakersLocation.coordinate, span};
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
    
    return annotationView;
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
