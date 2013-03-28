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
#import <QuartzCore/QuartzCore.h>

#import "Annotation.h"
#import "Photo.h"
#import "Business.h"
#import "UIView+AnimationTools.h"
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
    
    __weak IBOutlet UIView *enlargedPhotoViewOutlet;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UIView *loadingOverlay;
    //Just to deal with map zoom issue
    BOOL isZoomedInYet;
    __weak IBOutlet UIImageView *photoViewerUIImageView;
    BOOL didSelectThumbnail;
    __weak IBOutlet UILabel *bioLabel;
    __weak IBOutlet UIScrollView *bioScrollView;
    
}
- (IBAction)fullSizedPhotoTapped:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;

- (IBAction)closePhotoButtonPressed:(id)sender;

@end

@implementation FlickrMapViewController
@synthesize managedObjectContext;

dispatch_queue_t newQueue;

- (void)viewDidLoad
{
    [super viewDidLoad];
    isZoomedInYet = NO;
    didSelectThumbnail = NO;

    if(missLocationManager == nil)
    {
        missLocationManager = [[CLLocationManager alloc]init];
    }
    missLocationManager.delegate = self;
    [missLocationManager startUpdatingLocation];
//    NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 3];
//    [NSThread sleepUntilDate:future];
    
    //Code for bio page
    bioScrollView.contentSize = bioLabel.frame.size;
    
    
    //Add refresh button to Bookmarks viewController --CURRENTLY GOES TO BOOKMARKS, NEED TO WRITE METHOD FOR THIS
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed)];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];

    //Add bookmarks button to viewController
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkButtonPressed)];


    NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 2 ];
    [NSThread sleepUntilDate:future];
    //Created method "bookmarkButtonPressed, currently has no action - End edit
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;

    [mapView setShowsUserLocation:YES];
    
    //Overlay activate
    // Define an overlay that covers Colorado.
//    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:mapView.centerCoordinate radius:1000];
    CLLocationCoordinate2D mobileMakers = {
//        .latitude = 41.894032,
//        .longitude = -87.63472
        //Non-hard coded location here
        .latitude = missLocationManager.location.coordinate.latitude,
        .longitude = missLocationManager.location.coordinate.longitude
        
    };
    NSLog(@"%f %f", mobileMakers.latitude, mobileMakers.longitude);
    MKCircle *overlay = [MKCircle circleWithCenterCoordinate:mobileMakers radius:1000000000];

    
    overlay.title = @"Current region";
    
    [mapView addOverlay:overlay];
    
    //- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(CLLocationCoordinate2D)userLocation withMaxResults: (int) maxItems

    APIManager *mrAPIManager = [[APIManager alloc] initWithYelpSearch:@"'free%20wifi'" andLocation:mobileMakers withMaxResults:6];
    
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
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 250, 250);
    
    MKCoordinateSpan span =
    {
        //        .latitudeDelta = 0.01810686f,
        //        .longitudeDelta = 0.01810686f
        .latitudeDelta = 0.00950686f,
        .longitudeDelta = 0.00950686f
    };
    
    MKCoordinateRegion testRegion = MKCoordinateRegionMake(loc, span);
    
//    [userMapView setRegion:testRegion animated:YES];
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
//        .latitudeDelta = 0.01810686f,
//        .longitudeDelta = 0.01810686f
//        .latitudeDelta = 0.00950686f,
//        .longitudeDelta = 0.00950686f
        .latitudeDelta = 0.00550686f,
        .longitudeDelta = 0.00550686f

    };
    
    MKCoordinateRegion region = {missLocationManager.location.coordinate, span};
    //set region to mapview
    if (isZoomedInYet == NO)
    {
        
    [mapView setRegion:region animated:YES];
        isZoomedInYet = YES;
}
                       
                   
    for (int i = 0; i < venuesArray.count; i++)
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

}


-(void) addPhotosToMap: (NSMutableArray*)photosArray
{
    NSLog(@"%@", photosArray);
}


-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    newQueue = dispatch_queue_create("com.thePeanutGallery.maskGCDTest", NULL);
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
    if([annotation isKindOfClass: [MKUserLocation class]])
    {
        return nil;
    }
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    }
    

    //    [detailButton addTarget:self
    //                     action:@selector(goToYelpPage)
    //           forControlEvents:UIControlEventTouchUpInside];
    annotationView.canShowCallout = YES;

    annotationView.image = [UIImage imageNamed:@"wifiIcon.png"];
    
    //Let's set that custom image
    NSURL *flickrThumbnailURL = [NSURL URLWithString:selectedAnnotation.flickrThumbnailString];
    NSData *photoData = [NSData dataWithContentsOfURL:flickrThumbnailURL];
    UIImage *photoThumbnailImage = [UIImage imageWithData:photoData];
    UIImageView *imageWithFrame = [[UIImageView alloc] initWithImage:photoThumbnailImage];
    [imageWithFrame.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [imageWithFrame.layer setBorderWidth: 4.0];
    [annotationView addSubview:imageWithFrame];

    //Add frame to annotation
//    annotationView.image = [UIImage imageNamed:[NSString stringWithFormat:@"F.png"]];
//    
//    UIImage *frame = [UIImage imageNamed:[NSString stringWithFormat:@"F.png"];
//                      UIImage *image = photoThumbnailImage;
//                      
//                      UIGraphicsBeginImageContext(CGSizeMake(pin.size.width, pin.size.height));
//                      
//                      [frame drawInRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//                      [image drawInRect:CGRectMake(4, 4, 60, 60)]; // the frame your inner image
//                      //maybe you should draw the left bottom icon here,
//                      
//                      
//                      //then set back the new image, done
//                      annotationView.image = UIGraphicsGetImageFromCurrentImageContext();
//                      
//                      UIGraphicsEndImageContext();
    
    
    
    annotationView.image = photoThumbnailImage;

//    dispatch_async(newQueue,^void(void)
//                   {
//                       UIImage * mask = [UIImage imageNamed:@"circleMask.png"];
//                       UIImage *maskedAnnotationImage = [self createMaskWith:mask onImage:photoThumbnailImage];
//                       dispatch_async(dispatch_get_main_queue(),^void (void)
//                                      {
//                                          annotationView.image = photoThumbnailImage;
//                                      });
//                       
//                   });

    //Set the imageView inside the 
    UIImageView *photoContainer = [[UIImageView alloc] initWithImage:photoThumbnailImage];

    photoContainer.contentMode = UIViewContentModeScaleAspectFit;
    
    UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,32,32)];

    
    leftCAV.clipsToBounds = YES;
    [leftCAV addSubview : photoContainer];

    annotationView.leftCalloutAccessoryView = leftCAV;
    
    //annotationView.image = maskedAnnotationImage;
    annotationView.rightCalloutAccessoryView = detailButton;

    
    //Move "add bookmark" notification off-screen
    //Re-enable refresh button
    [UIView animateWithDuration:3.5 delay:2.0 options:nil animations:^(void) { loadingOverlay.alpha = 0; } completion:^(BOOL finished){    [self.navigationItem.leftBarButtonItem setEnabled:YES];
}];

//    [UIView animateWithDuration:3.5 animations:^(void) {
//        loadingOverlay.alpha = 0;}];
    
    
    return annotationView;
}

//Annotation overlay method
- (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {
    UIGraphicsBeginImageContext(image1.size);
    
    // Draw image1
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    
    // Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
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
        
        aView.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
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
    
    if([view.annotation isKindOfClass: [MKUserLocation class]])
        
    {
        return;
    }
    if (didSelectThumbnail == NO)
    {
        didSelectThumbnail = YES;
        [view squishImage];
     
        selectedAnnotation = view.annotation;
        [self displayFullSizedImageForSelectedAnnotation:selectedAnnotation];
        
        [enlargedPhotoViewOutlet lowerImageView];
    }
    else
    {
        selectedAnnotation = view.annotation;
        [self displayFullSizedImageForSelectedAnnotation:selectedAnnotation];

    }
}

- (void)displayFullSizedImageForSelectedAnnotation:(Annotation*)annotation
{
    // grab the medium sized version of the annotion image from flickr
    NSString *photoFullSizeURLString = [annotation.flickrThumbnailString stringByReplacingOccurrencesOfString:@"s.jpg" withString:@"n.jpg"];
    NSURL *photoFullSizeURL = [NSURL URLWithString:photoFullSizeURLString];
    NSData *photoData = [NSData dataWithContentsOfURL:photoFullSizeURL];
    UIImage *photoFullSize = [UIImage imageWithData:photoData];
    
    // adjust the containing view and imageView to match the photo's aspect ratio
    float photoWidth = photoFullSize.size.width;
    float photoHeight = photoFullSize.size.height;
    float photoAspectRatio = photoWidth/photoHeight;
    
    float imageViewWidth = photoViewerUIImageView.frame.size.width;
    float imageViewHeight = imageViewWidth/photoAspectRatio;
        
    CGRect scaledImageView = CGRectMake(5.0f, 5.0f, imageViewWidth, imageViewHeight);
    [photoViewerUIImageView setFrame:scaledImageView];
    photoViewerUIImageView.image = photoFullSize;
    
    CGRect scaledSuperView = CGRectMake(10.0f, 10.0f, imageViewWidth + 10, imageViewHeight + 10);
    [photoViewerUIImageView.superview setFrame:scaledSuperView];
}

- (IBAction)fullSizedPhotoTapped:(id)sender
{
    latitudeToPass = selectedAnnotation.coordinate.latitude;
    longitudeToPass = selectedAnnotation.coordinate.longitude;
    photoTitleToPass = selectedAnnotation.title;
    photoThumbnailStringToPass = selectedAnnotation.urlString;
    
    [self performSegueWithIdentifier:@"toYelpMapView" sender:nil];
}

- (IBAction)infoButtonPressed:(id)sender {
}

- (IBAction)closePhotoButtonPressed:(id)sender
{
    if (didSelectThumbnail == YES) {
        [enlargedPhotoViewOutlet raiseImageView];
    }
    
    
    didSelectThumbnail = NO;
}


//
// User taps on disclosure button to see more Yelp data.
//
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
   
    
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
    [mapView removeOverlays:mapView.overlays];
    
    [self.navigationItem.leftBarButtonItem setEnabled:NO];

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