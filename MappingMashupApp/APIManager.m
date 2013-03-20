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
{
    float latitude;
    float longitude;
}

@synthesize apiCall,flickrPhotosArray, yelpVenuesArray;

#pragma mark - Custom Initializers

//
// Initialize Yelp APIManager w/ custom API call
// Passes in custom search string and user's current location
//
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(CLLocationManager*)userLocation
{
    
    latitude = 41.894032;
    longitude = -87.634742;
    int maxItems = 6;
    float radius = 0.402336;
    
 //   userLocation.location.coordinate.latitude;
    
    //David's Yelp API key
    //ylWkpXJFz6-ZI3PvDG519A
    
    apiCall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=%f&limit=%d&ywsid=z8HZy2Hb2axZox05xfTW9w", search, latitude, longitude, radius, maxItems];
               
               
               
               
               
               //@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=1&limit=5&ywsid=z8HZy2Hb2axZox05xfTW9w",search, latitude, longitude];
               
               
               //userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude];
   
               
               //Restricting search to 5 results for now - 3.18.13
    
    // SHOULD WE BE KICKING OFF THE SEARCHES HERE?
    return self;
}

//
// Initialize Flickr APIManager w/ custom API call
// Passes in custom search string and user's current location
//
- (APIManager*)initWithFlickrSearch:(NSString*)search andVenue:(Venue*)venue
{
//    apiCall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&tags=%@&format=json&nojsoncallback=1&lat=%f&lon=%f&radius=0.5&extras=geo", search, venue.latitude, venue.longitude];
    

    
        apiCall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&tags=%@&format=json&nojsoncallback=1&lat=%@&lon=%@&radius=0.5&extras=geo", search, [NSString stringWithFormat:@"%f", venue.latitude], [NSString stringWithFormat:@"%f", venue.longitude]];
//    
    NSLog(@"%@", apiCall);
    
    
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
                                     
                                     [[self delegate]addPinsToMap:yelpVenuesArray];
                                     //NSLog(@"%@", yelpBusinessesArray);

                                 }
                        failBlock:^ void (YKHTTPError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Yelp Error: %@", [error description]);
                                     }
                                 }
     ];
    
    //
    //COMMENT FROM PAUL
    //How does this return the array?
    //
    
    // return array to view controller
    return yelpVenuesArray;
}

- (NSMutableArray*)createVenuesArray:(NSArray *)jsonArray
{
    yelpVenuesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in jsonArray)
    {
//        float latitude = [[business valueForKey:@"latitude"] floatValue];
//        float longitude = [[business valueForKey:@"longitude"] floatValue];
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentVenue = [[Venue alloc] init];
        currentVenue.name = [business valueForKey:@"name"];
        //currentVenue.location = loc;
        currentVenue.yelpURL= [business valueForKey:@"url"];
        currentVenue.longitude =[[ business valueForKey:@"longitude"] floatValue];
        currentVenue.latitude = [[business valueForKey:@"latitude"] floatValue];
        
        [yelpVenuesArray addObject:currentVenue];
        
    }
    return yelpVenuesArray;
    
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
                                                     //[self createPhotosArray:flickrPhotosArray];
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
