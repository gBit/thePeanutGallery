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

#import "Annotation.h"
#import "Photo.h"
#import "Business.h"

//Paul Testing - delete if this comment is still here on 3/24
#import "ResultsManager.h"

@interface FlickrMapViewController ()
{
    LocationManager *locationManager;
    Annotation *selectedAnnotation;
    //NSMutableArray *venuesArray;
    float latitudeToPass;
    float longitudeToPass;
    NSString * photoTitleToPass;
    NSString * photoThumbnailStringToPass;
    
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *loadingOverlay;
}


@end

@implementation FlickrMapViewController
@synthesize managedObjectContext;

dispatch_queue_t myQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //God help us, please make the location services work! Puh_LEASE JESUS
    [self startLocationUpdates];
    
    myQueue = dispatch_queue_create("com.thePeanutGallery.flickrGCDTest", NULL);
    
    //Add refresh button to Bookmarks viewController --CURRENTLY GOES TO BOOKMARKS, NEED TO WRITE METHOD FOR THIS
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    //Add bookmarks button to viewController
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkButtonPressed)];

    
    
    //Created method "bookmarkButtonPressed, currently has no action - End edit
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // Location Services
    locationManager = appDelegate.locationManager;
    [mapView setShowsUserLocation:YES];
    
    //Overlay activate
    // Define an overlay that covers Colorado.
//    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:mapView.centerCoordinate radius:1000];
    CLLocationCoordinate2D mobileMakers = {
        .latitude = 41.894032,
        .longitude = -87.63472
    };
    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:mobileMakers radius:100000];

    
    overlay.title = @"Current region";
    
    [mapView addOverlay:overlay];
    
    
    APIManager *mrAPIManager = [[APIManager alloc] initWithYelpSearch:@"free%20wifi" andLocation:missLocationManager];
    
    //deleagtion begins
    mrAPIManager.delegate = self;
     
    // Allocate objects
    // [possibly allocate the venuesArray later?]
   
    [mrAPIManager searchYelpThenFlickrForDelegates];
    
    ResultsManager *mrResultsManager = [[ResultsManager alloc]initWithAllFetchedResults];
    [mrResultsManager removeVenuesOverLimit];
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
//    Annotation *annotation = [[Annotation alloc]initWithCoordinate:coord
//                                                             title:@"title"
//                                                          subtitle:@"Somebody does not want poop"
//                                                           urlString:@"http://www.catstache.biz"];
//    //add annotation to mapview
//    [mapView addAnnotation:annotation];
    
    //zoom to region of location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    
    [mapView setRegion:region animated:YES];
    
    [locationManager stopUpdatingLocation];
}

-(void)didReceiveFlickrData:(NSMutableArray*)photosArray
{
    [self addPinsToMap:photosArray];
}


-(void)didReceiveYelpData: (NSMutableArray*)venuesArray
{
    
    //[self addPinsToMap:venuesArray];
}


- (void)addPinsToMap:(NSMutableArray*)venuesArray;
{
    
    // make region our area
    MKCoordinateSpan span =
    {
        .latitudeDelta = 0.01810686f,
        .longitudeDelta = 0.01810686f
    };
    
    MKCoordinateRegion region = {missLocationManager.location.coordinate, span};
    //set region to mapview
    [mapView setRegion:region animated:YES];
    
    
    dispatch_async(myQueue, ^void(void)
                   {
                       
                   
    for (int i = 0; i < 4; i++)
    {
        //CLLocation *venueLocation = [[venuesArray objectAtIndex:i] location];
        NSString *venueName = [[venuesArray objectAtIndex:i] name];
        NSString * venueURL = [[venuesArray objectAtIndex:i] urlString];
        
        //coordinate make
        
        float annotationLatitude =[[[venuesArray objectAtIndex:i] valueForKey:@"latitude"] floatValue];
        float annotationLongitude =[[[venuesArray objectAtIndex:i] valueForKey:@"longitude"] floatValue];
    
        CLLocationCoordinate2D venueCoordinate = {annotationLatitude, annotationLongitude};

        //NSString *urlString = [[venuesArray objectAtIndex:i] valueForKey:@"yelpURL"];
        NSString *urlString = [[venuesArray objectAtIndex:i] valueForKey:@"imageURL"];
        
//        Annotation *myAnnotation = [[Annotation alloc] initWithCoordinate:venueCoordinate title:venueName subtitle:@"Demo Subtite" urlString:urlString];
        
        Annotation *myAnnotation = [[Annotation alloc] initWithCoordinate:venueCoordinate title:venueName subtitle:venueURL urlString:urlString];
        myAnnotation.flickrThumbnailString = [[venuesArray objectAtIndex:i] imageURL];
        
        //This line is what is used to populate the next segue's data
        selectedAnnotation = myAnnotation;

        //add to map
        [mapView addAnnotation:myAnnotation];
        
    }
                       });

}


-(void) addPhotosToMap: (NSMutableArray*)photosArray
{
    NSLog(@"%@", photosArray);
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
    
    //Let's set that custom image
    NSURL *flickrThumbnailURL = [NSURL URLWithString:selectedAnnotation.flickrThumbnailString];
    //making the request online for the photo
    NSData *photoData = [NSData dataWithContentsOfURL:flickrThumbnailURL];
    UIImage *photoThumbnailImage = [UIImage imageWithData:photoData];
    //Now mask the image

    UIImage * mask = [UIImage imageNamed:@"circleMask.png"];
    UIImage *maskedAnnotationImage = [self createMaskWith:mask onImage:photoThumbnailImage];
    
    //Add the shine - can do later
//    UIImage *backgroundImage = maskedAnnotationImage;
//    UIImage *watermarkImage = [UIImage imageNamed:@"circleMaskShine"];
//    
//    UIGraphicsBeginImageContext(backgroundImage.size);
//    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
//    [watermarkImage drawInRect:CGRectMake(backgroundImage.size.width - watermarkImage.size.width, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
//    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    //Set the imageView inside the 
    UIImageView *photoContainer = [[UIImageView alloc] initWithImage:photoThumbnailImage];

    photoContainer.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    leftCAV.clipsToBounds = YES;
    [leftCAV addSubview : photoContainer];

    annotationView.leftCalloutAccessoryView = leftCAV;
    
    annotationView.image = maskedAnnotationImage;
    annotationView.rightCalloutAccessoryView = detailButton;

    if([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    
    //Maybe stop loading scren here?
    [UIView animateWithDuration:2 animations:^(void) {
        loadingOverlay.alpha = 0;}];
    
    
    return annotationView;
}

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

//Method for creating a map overlay
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKCircle class]])
    {
        MKCircleView*    aView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay];
        
        aView.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        aView.strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
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
    selectedAnnotation = view.annotation;
    
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
    NSLog(@"%@", view.annotation);
    //These instance variables will be passed in the segue
    latitudeToPass = selectedAnnotation.coordinate.latitude;
    longitudeToPass = selectedAnnotation.coordinate.longitude;
    photoTitleToPass = selectedAnnotation.title;
    photoThumbnailStringToPass = selectedAnnotation.urlString;
    
    [self performSegueWithIdentifier:@"toYelpMapView" sender:nil];
    
}

-(void)refreshButtonPressed
{
    [mapView removeAnnotations : mapView.annotations ];
    [UIView animateWithDuration:0.5 animations:^(void) {
        loadingOverlay.alpha = 1;}];
    [self viewDidLoad];
}


# pragma mark - Transitions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toYelpMapView"])
    {
    YelpMapViewController *ymvc = [segue destinationViewController];
    ymvc.originPhotoLongitude = longitudeToPass;
    ymvc.originPhotoLatitude = latitudeToPass;
        ymvc.originPhotoTitle = photoTitleToPass;
        ymvc.originPhotoThumbnailString = photoThumbnailStringToPass;
    }
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
    [self performSegueWithIdentifier: @"toBookmarksAndHistory" sender:self];

}

# pragma  mark - End of document

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end