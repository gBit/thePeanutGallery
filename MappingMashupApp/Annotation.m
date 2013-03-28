//
//  Annotation.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinate,title,subtitle, urlString, latitude, longitude, name, phone, isBookmarked, viewDate, yelpURLString, photo;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
                   title:(NSString*)titleString
                subtitle:(NSString*)subtitleString
               urlString:(NSString *)urlString
{
    if (self = [super init])
    {
        self.coordinate = coord;
        self.title = titleString;
        self.subtitle = subtitleString;
        self.urlString = urlString;
    }
    return self;
}
@end