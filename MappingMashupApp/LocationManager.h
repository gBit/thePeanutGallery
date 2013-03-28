//
//  LocationManager.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"


@interface LocationManager : NSObject <CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

-(void)stopUpdatingLocation;

//- (LocationManager*)init;

//- (LocationManager *)initWithLatitude:(float)latitude andLongitude:(float)longitude;

- (id)initWithCurrentLocationAndUpdates;
//- (void)retrieveFullSizedImageForSelectedAnnotation:(Annotation*)annotation;

@end
