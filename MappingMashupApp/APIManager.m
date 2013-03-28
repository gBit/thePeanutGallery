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
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(CLLocationCoordinate2D)userLocation withMaxResults: (int) maxItems
{
//    
//    float latitude = 41.894032;
//    float longitude = -87.634742;
    float latitude = userLocation.latitude;
    NSLog(@"%f", latitude);
    float longitude = userLocation.longitude;
    NSLog(@"%f", longitude);
    
//     maxItems = 6;
    float radius = 0.802336;
    

    
    //'Ross''s Yelp API key
    //z8HZy2Hb2axZox05xfTW9w
    
    //Emily's Yelp Key
    //xltTZDS7mgHV7wtu8MkZSg
    
    //Paul's Yelp Key
    //0mtAebqxwAxzHVOPI_OIyQ
    
    //David's Yelp Key
    //ylWkpXJFz6-ZI3PvDG519A
    
    //ARC4Random goes in here.
    NSString *keyToUse = @"";
    
    switch (arc4random()%4) {
        case 0:
            keyToUse = @"z8HZy2Hb2axZox05xfTW9w";
            break;
        case 1:
            keyToUse = @"xltTZDS7mgHV7wtu8MkZSg";
            break;
        case 2:
            keyToUse = @"0mtAebqxwAxzHVOPI_OIyQ";
            break;
        case 3:
            keyToUse = @"ylWkpXJFz6-ZI3PvDG519A";
            break;          
        default:
            keyToUse = @"z8HZy2Hb2axZox05xfTW9w"; // Emily's Yelp Key
            NSLog(@"Did not return a proper Yelp key, returned default on random test");
            break;
    }
    
    //Eventually, add if statement here if we need it, to cycle through limited-use keys
    
    yelpAPICall = [NSString stringWithFormat:@"http://api.yelp.com/business_review_search?term=%@&lat=%f&long=%f&radius=%f&limit=%d&ywsid=%@", search, latitude, longitude, radius, maxItems, keyToUse];
    NSLog(@"%@", yelpAPICall);
    
    
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
                                     
                                     NSString *search = @"color,+colorful,+shadow,+macro,+graffiti,+architecture,+street";
                                     NSString* latitude = [[yelpBusinessesArray objectAtIndex:i] valueForKey:@"latitude"];
                                     NSString *longitude = [[yelpBusinessesArray objectAtIndex:i] valueForKey:@"longitude"] ;

                                     
                                         //Paul's Flickr API Key 8ee0fab323e06c0f242ddc5e43e5ef2d
                                         //Em's Flickr API Key 90087da25a0e607ed65734c6bbd4bc01dec7b05e
                                         //Ross Flickr API Key 4dcd4b336fc303a2d36023d3c4c1b214
                                         //David FLickr API Key b4a287d18b3f7398ffb4ab9f1b961e22
                                         
                                         NSString *flickrKeyToUse = @"";
                                         
                                         switch (arc4random()%4) {
                                             case 0:
                                                 flickrKeyToUse = @"90087da25a0e607ed65734c6bbd4bc01dec7b05e";
                                                 break;
                                             case 1:
                                                 flickrKeyToUse = @"4dcd4b336fc303a2d36023d3c4c1b214";
                                                 break;
                                             case 2:
                                                 flickrKeyToUse = @"8ee0fab323e06c0f242ddc5e43e5ef2d";                                                  break;
                                             case 3:
                                                 flickrKeyToUse = @"b4a287d18b3f7398ffb4ab9f1b961e22";
                                                 break;          
                                             default:
                                                 flickrKeyToUse = @"4dcd4b336fc303a2d36023d3c4c1b214"; // Ross' Flickr Key
                                                 NSLog(@"Did not return a proper Yelp key, returned default on random test");
                                                 break;
                                         }
                                         
                                         flickrAPICall = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&format=json&nojsoncallback=1&lat=%@&lon=%@&radius=0.1&per_page=2&sort=interestingness-desc&content_type=1&extras=url_sq%%2C+geo%%2C+o_dims", flickrKeyToUse, search, latitude, longitude];
                                         NSLog(@"%@", flickrAPICall);
                                         
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
        currentVenue.phone = [business valueForKey:@"address1"];
        
        
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
