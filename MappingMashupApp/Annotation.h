//
//  Annotation.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *urlString;





//these are properties we need  on a pinAnnotation to make an entity.  We may be duplicating info above.  Added by David 3/21/13
    @property (nonatomic, retain) NSNumber * latitude;
    @property (nonatomic, retain) NSNumber * longitude;
    @property (nonatomic, retain) NSString * name;
    @property (nonatomic, retain) NSString * phone;
    @property (nonatomic, retain) NSNumber * isBookmarked;
    @property (nonatomic, retain) NSDate * viewDate;
    @property (nonatomic, retain) NSString * yelpURLString;
    @property (nonatomic, retain) NSSet *photo;



//- initWithPosition:(CLLocationCoordinate2D)coordinates;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord
                   title:(NSString*)titleString
                subtitle:(NSString*)subtitleString
                 urlString:(NSString*)urlString;

@end
