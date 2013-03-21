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
{
    NSString *yelpAPICall;
    NSString *flickrAPICall;
}

@property (strong, nonatomic) id <APIManagerDelegate> delegate;

- (APIManager*)initWithFlickrSearch:(NSString*)search andVenue:(Venue*)venue;
- (APIManager*)initWithYelpSearch:(NSString*)search andLocation:(LocationManager*)userLocation;

- (void)searchYelpThenFlickrForDelegates;
- (void)searchYelpForDelegates;
- (NSMutableArray*)searchFlickr;


@end
