//
//  APIManager.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YelpKit/YelpKit.h>
#import "DataSourceDelegate.h"
#import "LocationManager.h"

@interface APIManager : NSObject

@property (strong, nonatomic) NSArray *flickrPhotosArray;
@property (strong, nonatomic) NSArray *yelpBusinessesArray;
@property (strong, nonatomic) NSString *apiCall;

@property (strong, nonatomic) id <DataSourceDelegate> delegate;


- (APIManager*)initWithFlickrSearch:(NSString*)search andLocation:(LocationManager*)userLocation;

- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(LocationManager*)userLocation;

//the getter and the setting of the json from flickr
- (void)getFlickrJSON;
- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError;


//the getting of the json from yelp
- (void)getYelpJSON;
- (void)setUpYelpVenuesWithData: (id)data;


@end
