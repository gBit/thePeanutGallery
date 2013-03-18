//
//  Photo.h
//  MappingMashupApp
//
//  Created by StopBitingMe on 3/17/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * fullSizedURL;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * thumbnailURL;
@property (nonatomic, retain) Business *business;

@end
