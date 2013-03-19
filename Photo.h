//
//  Photo.h
//  MappingMashupApp
//
//  Created by David Johnston on 3/19/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Business;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * fullSizedURLString;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * thumbnailURLString;
@property (nonatomic, retain) Business *business;

@end
