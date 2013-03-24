//
//  BookmarkedBusiness.h
//  MappingMashupApp
//
//  Created by David Johnston on 3/24/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BookmarkedBusiness : NSManagedObject

@property (nonatomic, retain) NSString * yelpURLString;
@property (nonatomic, retain) NSDate * viewDate;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * isBookmarked;

@end
