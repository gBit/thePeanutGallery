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

// FUTURE TASKS:
// venue metadata
// array of nearby flickr URLs

// OTHER NOTES:
// this one will be core data


@end

