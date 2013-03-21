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

#pragma mark - Custom Initializers

//
// Initialize Yelp APIManager w/ custom API call
// Passes in custom search string and user's current location
//
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(CLLocationManager*)userLocation
{
    
    float latitude = 41.894032;
    float longitude = -87.634742;
    int maxItems = 6;
    float radius = 0.402336;
    
    //David's Yelp API key
    //ylWkpXJFz6-ZI3PvDG519A
    
    //'Ross''s Yelp API key
    //z8HZy2Hb2axZox05xfTW9w
    
    //Emily's Yelp Key
    //xltTZDS7mgHV7wtu8MkZSg
    
    yelpAPICall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=%f&limit=%d&ywsid=z8HZy2Hb2axZox05xfTW9w", search, latitude, longitude, radius, maxItems];
    return self;
}

#pragma mark - Yelp Methods

- (void)searchYelpThenFlickrForDelegates
{
    YKURL *yelpURL = [YKURL URLString:yelpAPICall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id data)
                                 {
                                     NSDictionary *jsonDictionary = (NSDictionary *)data;
                                     NSArray *yelpBusinessesArray = [jsonDictionary valueForKey:@"businesses"];
                                     NSMutableArray *venuesArray = [self createVenuesArray:yelpBusinessesArray];
                                     
                                     [[self delegate] didReceiveYelpData:venuesArray];
                                     //
                                     //this will only start a search of one venue,
                                     //update to create method to loop through venues array...
                                     //
                                     int i = 0;
                                     for (i=0; i < yelpBusinessesArray.count; i++)
                                     {
                                     
                                     NSString *search = @"color";
                                     NSString* latitude = [[yelpBusinessesArray objectAtIndex:i] valueForKey:@"latitude"];
                                     NSString *longitude = [[yelpBusinessesArray objectAtIndex:i] valueForKey:@"longitude"] ;

                                     
                                         //Paul's Flickr API Key 8ee0fab323e06c0f242ddc5e43e5ef2d
                                         //Em's Flickr API Key 90087da25a0e607ed65734c6bbd4bc01dec7b05e
                                         //Ross Flickr API Key 4dcd4b336fc303a2d36023d3c4c1b214
                                         
                                     flickrAPICall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4dcd4b336fc303a2d36023d3c4c1b214&tags=%@&format=json&nojsoncallback=1&lat=%@&lon=%@&radius=0.5&extras=url_sq%%2C+geo", search, latitude, longitude];

                                         [self searchFlickrWithLatitude:latitude andLongitude:longitude];
                                     }
                                     
                                     /*
                                     NSMutableArray *photosArray = [self searchFlickrWithLatitude:latitude andLongitude:longitude];
                                      */


                                 }
                        failBlock:^ void (YKHTTPError *error)
                                 {
                                     if (error)
                                     {
                                         NSLog(@"Yelp Error: %@", [error description]);
                                     }
                                 }
     ];
}

//New method for just yelp search, no flickr integration
//Use this in yelpMapViewController only
- (void)searchYelpForDelegates
{
    YKURL *yelpURL = [YKURL URLString:yelpAPICall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id data)
     {
         NSDictionary *jsonDictionary = (NSDictionary *)data;
         NSArray *yelpBusinessesArray = [jsonDictionary valueForKey:@"businesses"];
         NSMutableArray *venuesArray = [self createVenuesArray:yelpBusinessesArray];
         
         [[self delegate] didReceiveYelpData:venuesArray];
         }
     
                        failBlock:^ void (YKHTTPError *error)
     {
         if (error)
         {
             NSLog(@"Yelp Error: %@", [error description]);
         }
     }
     ];
}


- (NSMutableArray*)createVenuesArray:(NSArray *)jsonArray
{
    NSMutableArray *yelpVenuesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in jsonArray)
    {
//        float latitude = [[business valueForKey:@"latitude"] floatValue];
//        float longitude = [[business valueForKey:@"longitude"] floatValue];
//        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentVenue = [[Venue alloc] init];
        currentVenue.name = [business valueForKey:@"name"];
        //currentVenue.location = loc;
        currentVenue.urlString= [business valueForKey:@"url"];
        currentVenue.longitude =[[ business valueForKey:@"longitude"] floatValue];
        currentVenue.latitude = [[business valueForKey:@"latitude"] floatValue];
        currentVenue.photoTitle = [business valueForKey:@"title"];
        
        [yelpVenuesArray addObject:currentVenue];
        
    }
    return yelpVenuesArray;
    
}

#pragma mark - Flickr Methods

- (void)searchFlickrWithLatitude:(NSString*)latitude andLongitude:(NSString*)longitude
{
    NSURLRequest *flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:flickrAPICall]];
    
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
                                                     NSArray *jsonFlickrArray = [[NSArray alloc]init];
                                                     jsonFlickrArray = [[jsonDictionary valueForKey:@"photos"] valueForKey:@"photo"];
                                                     NSMutableArray *flickrPhotosArray = [self createPhotosArray:jsonFlickrArray];
                                                     [[self delegate] didReceiveFlickrData:flickrPhotosArray];
                                                 }
                                             }
     ];
}

- (NSMutableArray *)createPhotosArray:(NSArray *)jsonFlickrArray
{
    NSMutableArray *flickrPhotosArray = [[NSMutableArray alloc]init];
    for (NSDictionary *photo in jsonFlickrArray)
    {
        float latitude = [[photo valueForKey:@"latitude"] floatValue];
        float longitude = [[photo valueForKey:@"longitude"] floatValue];
        //CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentPhoto = [[Venue alloc] init];
        currentPhoto.name = [photo valueForKey:@"title"];

        currentPhoto.longitude = longitude;
        currentPhoto.latitude = latitude;
        currentPhoto.urlString= [photo valueForKey:@"url"];
        currentPhoto.imageURL = [photo valueForKey:@"url_sq"];
        //Include new property and line to assign value for thumbnail URL
        
        [flickrPhotosArray addObject:currentPhoto];
    }
    return flickrPhotosArray;
}

@end
