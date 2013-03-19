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

@synthesize apiCall,flickrPhotosArray, venuesArray;


//api method call for flickr
- (APIManager*)initWithFlickrSearch:(NSString*)search andLocation:(LocationManager*)userLocation
{
    apiCall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=bd02a7a94fbe1f4c40a1661af4cb7bbe&tags=%@&format=json&nojsoncallback=1&lat=%f&lon=%f&radius=0.5&extras=geo", search, userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    return self;
}

//api method call for yelp
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(LocationManager*)userLocation
{
    apiCall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=1&limit=5&ywsid=z8HZy2Hb2axZox05xfTW9w",search, userLocation.coordinate.latitude, userLocation.coordinate.longitude];
    //Restricting search to 5 results for now - 3.18.13
    return self;
}

//method calll for returing the dicitionaries that we are getting from the api calls
- (void) getFlickrJSON
{
    NSURLRequest* flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:apiCall]];
    
    //not needed because it is the default
    //flickrRequest.HTTPMethod = @"GET";
    
    [NSURLConnection sendAsynchronousRequest:flickrRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^ void (NSURLResponse* myResponse, NSData* myData, NSError* theirError)
     {
         [self setArrayOfDictsFromFlickrJSONWithResponse:myResponse andData:myData andError:theirError];
         //[self.delegate grabArray:flickrPhotosArray];
         
     }];
}

//
//
//This came from YelpMapViewController and needs to be refactored
//
//
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

- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError
{
    
    if (theirError)
    {
        NSLog(@"Flickr Error: %@", [theirError description]);
    }
    else
    {
        NSError *jsonError;
        NSDictionary *myJSONDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:myData
                                                                                         options:NSJSONReadingAllowFragments
                                                                                           error:&jsonError];
        
        flickrPhotosArray = [[myJSONDictionary valueForKey:@"photos"] valueForKey:@"photo"];
    }
}

- (NSMutableArray*)getYelpArrayFromAPICall
{
    YKURL *yelpURL = [YKURL URLString:apiCall];
    [YKJSONRequest requestWithURL:yelpURL
                      finishBlock:^ void (id myData)
         {
             NSDictionary *jsonDictionary = (NSDictionary *)myData;
             NSArray *yelpBusinessesArray = [jsonDictionary valueForKey:@"businesses"];
             //
             //probably delete this delegate and push it to
             //createVenuesArray method
             //
             //[self.delegate grabArray:yelpBusinessesArray];
            [self createVenuesArray:yelpBusinessesArray];
         }
                        failBlock:^ void (YKHTTPError *error)
     {
         if (error)
         {
             NSLog(@"Error using Yelp: %@", [error description]);
         }
     }];
    
    // return array to view controller
    return venuesArray;
}

- (void)createVenuesArray:(NSArray *)jsonArray
{
    venuesArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *business in jsonArray)
    {
        float latitude = [[business valueForKey:@"latitude"] floatValue];
        float longitude = [[business valueForKey:@"longitude"] floatValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        Venue *currentVenue = [[Venue alloc] init];
        currentVenue.name = [business valueForKey:@"name"];
        currentVenue.location = loc;
        currentVenue.yelpURL= [business valueForKey:@"url"];
        
        [venuesArray addObject:currentVenue];
    }
}
@end
