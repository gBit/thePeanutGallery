//
//  LocationManager.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "LocationManager.h"


@implementation LocationManager
{
    CLLocationManager *locationManager;
}
//@synthesize coordinate;

//make our own version of cllocation, that currently is hard coded to MM
- (LocationManager *)init
{
    self = [super init];
    
    //coordinate.latitude = 41.894032;
    //coordinate.longitude = -87.634742;
    return self;
}

- (LocationManager *)initWithLatitude:(float)latitude andLongitude:(float)longitude
{
    self = [super init];
    //coordinate.latitude = latitude;
    //coordinate.longitude = longitude;
    return self;
}

- (id)initWithCurrentLocationAndUpdates
{
     //self = [super init];
     locationManager = [[CLLocationManager alloc] init];
     locationManager.delegate = self;
     [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
     
     [self startUpdatingLocations];
     
     return self;
}
//possibly delete
-(void)findLocation
{
    [locationManager startUpdatingLocation];
}
 
- (void)startUpdatingLocations
{
     locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
     locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
     [locationManager startUpdatingLocation];
}

-(void)stopUpdatingLocation
{
    [locationManager stopUpdatingLocation];
}
 
 - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
 {
     CLLocation* newestLocation = [locations objectAtIndex:0];
     NSLog(@"Hello world");
     if ( abs([newestLocation.timestamp timeIntervalSinceDate:[NSDate date]]) < 120)
     {
     //self.coordinate = newestLocation.coordinate;
     //NSLog(@"THIS IS THE LONGITUDE DUDE MOOD: %f", self.coordinate.longitude);
     
     }
 }

 - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

//- (void)retrieveFullSizedImageForSelectedAnnotation:(Annotation*)annotation
//{
//    // grab the medium sized version of the annotion image from flickr
//    NSString *photoFullSizeURLString = [annotation.flickrThumbnailString stringByReplacingOccurrencesOfString:@"s.jpg" withString:@"n.jpg"];
//    NSURL *photoFullSizeURL = [NSURL URLWithString:photoFullSizeURLString];
//    NSData *photoData = [NSData dataWithContentsOfURL:photoFullSizeURL];
//    UIImage *photoFullSize = [UIImage imageWithData:photoData];
//
//    // adjust the containing view and imageView to match the photo's aspect ratio
//    float photoWidth = photoFullSize.size.width;
//    float photoHeight = photoFullSize.size.height;
//    float photoAspectRatio = photoWidth/photoHeight;
//
//    float imageViewWidth = photoViewerUIImageView.frame.size.width;
//    float imageViewHeight = imageViewWidth/photoAspectRatio;
//
//    CGRect scaledImageView = CGRectMake(5.0f, 5.0f, imageViewWidth, imageViewHeight);
//    [photoViewerUIImageView setFrame:scaledImageView];
//    photoViewerUIImageView.image = photoFullSize;
//
//    CGRect scaledSuperView = CGRectMake(10.0f, 10.0f, imageViewWidth + 10, imageViewHeight + 10);
//    [photoViewerUIImageView.superview setFrame:scaledSuperView];
//}

@end
