//
//  Annotation.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinate,title,subtitle, yelpPageURL;

- initWithPosition:(CLLocationCoordinate2D *)coordinates
{
    if (self = [super init]) {
        self.coordinate = *(coordinates);
    }
    return self;
}

@end