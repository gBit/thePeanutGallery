//
//  YelpWebPageBrowser.h
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/17/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpWebPageBrowser : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSString *yelpURLString;

@end
