//
//  YelpWebPageBrowser.h
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/17/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Venue.h"

@interface YelpWebPageBrowser : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *yelpURLString;
@property (strong, nonatomic) NSDate *viewDate;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;






//        selectedBusiness.latitude = selectedAnnotation.latitude;
//        selectedBusiness.longitude = selectedAnnotation.longitude;
//        selectedBusiness.name = selectedAnnotation.name;
//        selectedBusiness.yelpURLString = selectedAnnotation.yelpURLString;
//        selectedBusiness.viewDate = selectedAnnotation.viewDate;

@end
