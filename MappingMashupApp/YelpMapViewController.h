//
//  YelpMapViewController.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "APIManager.h"

@interface YelpMapViewController : UIViewController <APIManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (assign, nonatomic) float originPhotoLatitude;
@property (assign, nonatomic) float originPhotoLongitude;
@property (assign, nonatomic) NSString * originPhotoTitle;
@property (assign, nonatomic) NSString * originPhotoThumbnailURL;

@end
