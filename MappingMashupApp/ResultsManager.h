//
//  ResultsManager.h
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ResultsManager : NSObject
{
    NSArray *allHistories;
    NSArray *oldVenues;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(ResultsManager*)initWithAllFetchedResults;
-(void)removeVenuesOverLimit;

@end
