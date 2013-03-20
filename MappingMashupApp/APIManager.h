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
#import <MapKit/MapKit.h>
#import "Venue.h"

@protocol APIManagerDelegate <NSObject>
@optional
-(void)didReceiveYelpData: (NSMutableArray*)venuesArray;
-(void)didReceiveFlickrData:(NSMutableArray*)photosArray;
@end

@interface APIManager : NSObject

@property (strong, nonatomic) NSString *apiCall;
@property (strong, nonatomic) NSMutableArray *yelpVenuesArray;
@property (strong, nonatomic) NSMutableArray *flickrPhotosArray;

@property (strong, nonatomic) id <DataSourceDelegate> delegate;

- (APIManager*)initWithFlickrSearch:(NSString*)search andVenue:(Venue*)venue;
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(LocationManager*)userLocation;

- (void)searchYelpAndSendToDelegates;
- (NSMutableArray*)searchFlickrParseResults;

//- (void)setArrayOfDictsFromFlickrJSONWithResponse:(NSURLResponse*)myResponse andData:(NSData*)myData andError:(NSError*)theirError;

@end
