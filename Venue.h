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
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *ratingURL;
@property (strong, nonatomic) NSString *urlString;
@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;
@property (assign, nonatomic) int reviewCount;
@property (assign, nonatomic) BOOL isClosed;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSMutableArray *flickrPhotos;
@property (strong, nonatomic) NSString *photoTitle;

@end

