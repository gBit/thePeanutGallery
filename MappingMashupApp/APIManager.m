//
//  APIManager.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "APIManager.h"
#import <YelpKit/YelpKit.h>
#import "Venue.h"

@implementation APIManager

@synthesize apiCall,flickrPhotosArray, yelpVenuesArray;

#pragma mark - Custom Initializers

//
// Initialize Yelp APIManager w/ custom API call
// Passes in custom search string and user's current location
//
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(LocationManager*)userLocation
{
    apiCall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=1&limit=5&ywsid=z8HZy2Hb2axZox05xfTW9w",search, userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    //Restricting search to 5 results for now - 3.18.13
    
    // SHOULD WE BE KICKING OFF THE SEARCHES HERE?
    return self;
}

//
// Initialize Flickr APIManager w/ custom API call
// Passes in custom search string and user's current location
//
- (APIManager*)initWithFlickrSearch:(NSString*)search andLocation:(LocationManager*)userLocation
{
    apiCall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&tags=%@&format=json&nojsoncallback=1&lat=%f&lon=%f&radius=0.5&extras=geo", search, userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    return self;
}

#pragma mark - Yelp Methods

- (NSMutableArray*)searchYelpParseResults
{
    YKURL *yelpURL = [YKURL URLString:apiCall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id data)
                                 {
                                     NSDictionary *jsonDictionary = (NSDictionary *)data;
                                     NSArray *yelpBusinessesArray = [jsonDictionary valueForKey:@"businesses"];
                                     [self createVenuesArray:yelpBusinessesArray];
                                 }
                        failBlock:^ void (YKHTTPError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Yelp Error: %@", [error description]);
                                     }
                                 }
     ];
    
    // return array to view controller
    return yelpVenuesArray;
}

- (void)createVenuesArray:(NSArray *)jsonArray
{
    yelpVenuesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in jsonArray)
    {
        float latitude = [[business valueForKey:@"latitude"] floatValue];
        float longitude = [[business valueForKey:@"longitude"] floatValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentVenue = [[Venue alloc] init];
        currentVenue.name = [business valueForKey:@"name"];
        currentVenue.location = loc;
        currentVenue.yelpURL= [business valueForKey:@"url"];
        
        [yelpVenuesArray addObject:currentVenue];
    }
}

#pragma mark - Flickr Methods

- (NSMutableArray*)searchFlickrParseResults
{
    NSURLRequest *flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:apiCall]];
    [NSURLConnection sendAsynchronousRequest:flickrRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^ void (NSURLResponse* response, NSData* data, NSError* error)
                                             {
                                                 if (error)
                                                 {
                                                     NSLog(@"Flickr Error: %@", [error description]);
                                                 }
                                                 else
                                                 {
                                                     NSError *error;
                                                     NSDictionary *jsonDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data
                                                                                                                                      options:NSJSONReadingAllowFragments
                                                                                                                                        error:&error];
                                                     
                                                     flickrPhotosArray = [[jsonDictionary valueForKey:@"photos"] valueForKey:@"photo"];
                                                     //
                                                     // IS THIS GOING TO BE A PROBLEM? (INSIDE BLOCK)
                                                     //
                                                     [self createPhotosArray:flickrPhotosArray];
                                                 }
                                             }
     ];
    return flickrPhotosArray;
}

//
//
// THIS NEEDS TO BE REVIEWED TO MAKE SURE IT WORKS/EXTEND FUNCTIONALITY
//
//
- (NSMutableArray *)createPhotosArray:(NSArray *)jsonArray
{
    flickrPhotosArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *photo in jsonArray)
    {
        float latitude = [[photo valueForKey:@"latitude"] floatValue];
        float longitude = [[photo valueForKey:@"longitude"] floatValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentPhoto = [[Venue alloc] init];
        currentPhoto.name = [photo valueForKey:@"name"];
        currentPhoto.location = loc;
        currentPhoto.yelpURL= [photo valueForKey:@"url"];
        
        [flickrPhotosArray addObject:currentPhoto];
    }
    return flickrPhotosArray;
}
@end
