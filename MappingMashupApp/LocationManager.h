//
//  LocationManager.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

- (LocationManager*)init;

- (LocationManager *)initWithLatitude:(float)latitude andLongitude:(float)longitude;

//- (id)initWithCurrentLocationAndUpdates;

@end
