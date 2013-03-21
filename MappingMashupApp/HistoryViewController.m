//
//  HistoryViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/20/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
{
    NSArray * testHistory;
}

@end

@implementation HistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"History";
    
    testHistory = [[NSArray alloc] initWithObjects:@"History 1", @"History 2", @"History 3", nil];
}

#pragma mark -- table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. declare a cell
    UITableViewCell * currentCell;
    
    //2. see if there are any cells we can reuse
    currentCell = [tableView dequeueReusableCellWithIdentifier:@"HistoryReuseIdentifier"];
	
    //3. if not, create one to use!
	if(currentCell == nil)
    {
        currentCell = [[UITableViewCell alloc]
                       initWithStyle:UITableViewCellStyleSubtitle
                       reuseIdentifier:@"HistoryReuseIdentifier"];
        currentCell.accessoryType =     UITableViewCellAccessoryDisclosureIndicator;
	}
	//4. change the textLabel to reflect the data we are using.
    
	currentCell.textLabel.text = [testHistory objectAtIndex:[indexPath row]];
    currentCell.detailTextLabel.text = @"Subtitle";
	return currentCell;
    
}

//When row is selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //The following occurs when you swipe to delete and hit delete.
        //[self deleteVenue:(Venue*)];
        
        //From vokal spies project, to delete on swipe...
//        Person * person = [displaySpies objectAtIndex:indexPath.row];
//        [self deletePerson:person];
//        
//        displaySpies = [self getCurrentSpies];
//        
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [tableView reloadData];
    }
}

//Delete an object from the History.
-(void)deleteVenue: (Venue*)venue
{
//    [self.myManagedObjectContext deleteObject:venue];
    NSError *error;
//    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Delete History item method failed.");
    }
}


#pragma mark -- segue methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YelpWebPageBrowser * ywpb = [segue destinationViewController];
    //Future Ross, this might break
    //ywpb.yelpURLString = selectedAnnotation.yelpPageURL;
    ywpb.yelpURLString = @"http://m.yelp.com";
    //Also, here pass the Business (managed object) herein to the Yelp WebPage browser.
}




#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
