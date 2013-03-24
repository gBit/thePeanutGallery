//
//  ResultsManager.m
//  MappingMashupApp
//
//  Created by gBit on 3/14/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "ResultsManager.h"
#import "Business.h"
@implementation ResultsManager

//I hope emily isnt woking on this
-(ResultsManager*)initWithAllFetchedResults
{
    self = [super init];
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    allHistories = [[NSArray alloc]init];
    
    allHistories = [self retrieveAllEntitiesNamed:@"Business"];
    
    return self;
}

-(NSArray *)retrieveAllEntitiesNamed:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    
    fetchRequest.entity = entity;
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

-(void)removeVenuesOverLimit
{

    for (int i = 4; i < allHistories.count; i++) {
        Business *business = [allHistories objectAtIndex:i];
        
        [self.managedObjectContext deleteObject:business];
        
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            NSLog(@"Bookmark cleanup failed.");
        }

    }
}

@end
