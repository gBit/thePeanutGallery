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
    CLLocationManager *locationManager;
    Annotation *selectedAnnotation;
    Annotation *originAnnotation;
    NSMutableArray *photosArray;
    
    __weak IBOutlet UIImageView *photoViewerUIImageView;
    __weak IBOutlet UIButton *photoViewerButton;
    __weak IBOutlet MKMapView *yelpMapView;
}
- (IBAction)largePhotoTapped:(id)sender;

-(void)addPinsToMap;
@end

@implementation YelpMapViewController
@synthesize managedObjectContext, originPhotoLatitude, originPhotoLongitude, originPhotoTitle, originPhotoThumbnailURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Location Services
    [yelpMapView setShowsUserLocation:YES];
    
    //Set map region to the imported lat/long
    CLLocationCoordinate2D originLocationCoordinate =
    {
        .latitude = originPhotoLatitude,
        .longitude = originPhotoLongitude
    };
    
    MKCoordinateSpan originSpan =
    {
//        .latitudeDelta = 0.01810686f,
//        .longitudeDelta = 0.01810686f
//        .latitudeDelta = 0.01450686f,
//        .longitudeDelta = 0.01450686f
        
        .latitudeDelta = 0.00750686f,
        .longitudeDelta = 0.00750686f
    };
    
    MKCoordinateRegion originRegion = {originLocationCoordinate, originSpan};
    
    APIManager *yelpAPIManager = [[APIManager alloc] initWithYelpSearch:@"free%20wifi" andLocation:originLocationCoordinate withMaxResults:15];
    yelpAPIManager.delegate = self;
    
    // Add Bookmarks button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkButtonPressed)];
    
    // Annotation
    originAnnotation = [[Annotation alloc] initWithCoordinate:originLocationCoordinate title:originPhotoTitle subtitle:@"Your Selected Photo" urlString:originPhotoThumbnailURL];
    
    selectedAnnotation = originAnnotation;
    
    // Darkening overlay on map, if we want one
    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:originLocationCoordinate radius:100000];
    overlay.title = @"Current region";
    [yelpMapView addOverlay:overlay];
    
    [yelpMapView setRegion:originRegion animated:YES];
    [yelpMapView addAnnotation:originAnnotation];
    
    [yelpAPIManager searchYelpForDelegates];
    
    [self retrieveFullSizedImageForSelectedPhoto:originPhotoThumbnailURL];
}

// working with existing structure, this passes in an NSString (as opposed to an Annotation)
// needs flexibility so it can be refactored and placed in the APIManager class
- (void)retrieveFullSizedImageForSelectedPhoto:(NSString*)photoThumbnailURL
{
    // grab the medium sized version of the annotion image from flickr
    NSString *photoFullSizeURLString = [photoThumbnailURL stringByReplacingOccurrencesOfString:@"s.jpg" withString:@"n.jpg"];
    NSURL *photoFullSizeURL = [NSURL URLWithString:photoFullSizeURLString];
    NSData *photoData = [NSData dataWithContentsOfURL:photoFullSizeURL];
    UIImage *photoFullSize = [UIImage imageWithData:photoData];
    
    // adjust the containing view and imageView to match the photo's aspect ratio
    float photoWidth = photoFullSize.size.width;
    float photoHeight = photoFullSize.size.height;
    float photoAspectRatio = photoWidth/photoHeight;
    
    // for this view, we've scaled it to 1/4 of the screen
    float imageViewWidth = photoViewerUIImageView.frame.size.width;
    float imageViewHeight = imageViewWidth/photoAspectRatio;
    
    // frame positioning is also adjusted from flickr view
    CGRect scaledImageView = CGRectMake(3.0f, 3.0f, imageViewWidth, imageViewHeight);
    [photoViewerUIImageView setFrame:scaledImageView];
    photoViewerUIImageView.image = photoFullSize;
    
    // now the superview
    CGRect scaledSuperView = CGRectMake(5.0f, 5.0f, imageViewWidth + 6, imageViewHeight + 6);
    [photoViewerUIImageView.superview setFrame:scaledSuperView];
    
    // and last, but not least, the button
    CGRect scaledButton = CGRectMake(0.0f, 0.0f, scaledSuperView.size.width + 10, scaledSuperView.size.height + 10);
    [photoViewerButton setFrame:scaledButton];
}


# pragma mark - User Location Methods
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
    for (int i = 0; i < venuesArray.count; i++)
    {
        NSString *venueName = [[venuesArray objectAtIndex:i] name];
        
        //coordinate make
        float annotationLatitude =[[[venuesArray objectAtIndex:i] valueForKey:@"latitude"] floatValue];
        float annotationLongitude =[[[venuesArray objectAtIndex:i] valueForKey:@"longitude"] floatValue];
        
        NSNumber *latitude = [[venuesArray objectAtIndex:i] valueForKey:@"latitude"];
        NSNumber *longitude = [[venuesArray objectAtIndex:i] valueForKey:@"longitude"];
        
        CLLocationCoordinate2D venueCoordinate = {annotationLatitude, annotationLongitude};
        
        NSString *urlString = [[venuesArray objectAtIndex:i] valueForKey:@"urlString"];

        Annotation *myAnnotation = [[Annotation alloc] initWithCoordinate:venueCoordinate title:venueName subtitle:nil urlString:urlString];
        myAnnotation.longitude = longitude;
        myAnnotation.latitude = latitude;
        myAnnotation.name = [[venuesArray objectAtIndex:i] valueForKey:@"name"];
        myAnnotation.viewDate = [NSDate date];
        myAnnotation.yelpURLString = urlString;
        myAnnotation.phone = [[venuesArray objectAtIndex:i] valueForKey:@"phone"];
        
        //add to map
        [yelpMapView addAnnotation:myAnnotation];
    }
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    
    //Code for specifically dealing with the origin photo
    if ([[annotation subtitle] isEqual: @"Your Selected Photo"])
    {
        annotationView = (MKPinAnnotationView*)annotationView;
        NSLog(@"%@", annotationView);
        return nil;
    }
    
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"wifiIcon.png"];
    annotationView.rightCalloutAccessoryView = detailButton;
    
    if([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    return annotationView;
}

//Method for creating a map overlay
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView*    aView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
        
        aView.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        aView.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        aView.lineWidth = 1;
        
        return aView;
    }
    
    return nil;
}

# pragma mark - User Actions
//
// User selects an annotation
//
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //If statement to prevent crash if you tap Current Location pin.
    if(![view.annotation isKindOfClass:[MKUserLocation class]])
    {
    selectedAnnotation = view.annotation;
    
    Business *selectedBusiness = [NSEntityDescription insertNewObjectForEntityForName:@"Business" inManagedObjectContext:managedObjectContext];
    
    selectedBusiness.latitude = selectedAnnotation.latitude;
    selectedBusiness.longitude = selectedAnnotation.longitude;
    selectedBusiness.name = selectedAnnotation.name;
    selectedBusiness.yelpURLString = selectedAnnotation.yelpURLString;
    selectedBusiness.viewDate = selectedAnnotation.viewDate;
        NSLog(@"Selected business view date:%@", selectedAnnotation.viewDate);
    selectedBusiness.phone = selectedAnnotation.phone;
    
    
        NSError *error;
        if (![managedObjectContext save:&error])
        {
            NSLog(@"failed to save: %@", [error userInfo]);
        }
    }
}

//Masking method
- (UIImage*) createMaskWith: (UIImage *)maskImage onImage:(UIImage*) subjectImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL,
                                        false);
    
    CGImageRef masked = CGImageCreateWithMask(subjectImage.CGImage, mask);
    
    UIImage *finalImage = [UIImage imageWithCGImage:masked];
    return finalImage;
}

//
// User taps on disclosure button to see more Yelp data.
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"This is the method we want!");
    [self performSegueWithIdentifier:@"toYelpWebPage" sender:nil];    
}

-(void) bookmarkButtonPressed
{
    NSLog(@"User pressed button to go to bookmarks");
    [self performSegueWithIdentifier: @"yelpPageToBookmarks" sender:self];
}

# pragma mark - Transitions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"toYelpWebPage"])
    {
        
    YelpWebPageBrowser * ywpb = [segue destinationViewController];

    ywpb.yelpURLString = selectedAnnotation.yelpURLString;
    ywpb.phone = selectedAnnotation.phone;
    ywpb.latitude = selectedAnnotation.latitude;
    ywpb.longitude = selectedAnnotation.longitude;
    ywpb.name = selectedAnnotation.name;
    ywpb.viewDate = [NSDate date];
    }
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

- (IBAction)largePhotoTapped:(id)sender {
    [yelpMapView selectAnnotation:originAnnotation animated:YES];
}
@end
