//
//  DataSourceDelegate.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataSourceDelegate <NSObject>

//- (void)grabArray:(NSArray *)data;

-(void)addPinsToMap:(NSArray*)data;

@end
