//
//  Venue.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataSourceDelegate.h"
#import "LocationManager.h"

@interface Venue : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) NSString *address;
//Should the phone property be an NSString?
@property (strong, nonatomic) NSString *phone;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;
@property (assign, nonatomic) int reviewCount;
@property (assign, nonatomic) BOOL isClosed;
@property (strong, nonatomic) NSString *ratingURL;
@property (strong, nonatomic) NSString *yelpImageURL;
@property (strong, nonatomic) NSString *yelpURL;
//This property will store the url of nearby photos
@property (strong, nonatomic) NSMutableArray *flickrPhotos;

/*
 NSString *yelpName;
 NSString *yelpAddress;
 NSString *yelpPhone;
 NSString *yelpLatitude;
 NSString *yelpLongitude;
 NSString *yelpReviewCount;
 NSString *yelpIsClosed;
 NSURL *yelpRatingURL;
 */

// FUTURE TASKS:
// venue metadata
// array of nearby flickr URLs

// OTHER NOTES:
// this one will be core data

//


@end

