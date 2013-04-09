//
//  HistoryViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/20/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "HistoryViewController.h"
#import "AppDelegate.h"
#import "Business.h"

@interface HistoryViewController ()
{
    NSArray * testHistory;
    NSArray *historyArray;
    NSMutableArray *reverseHistoryArray;
    NSArray *bookmarkArray;
    __weak IBOutlet UITableView *historyTableViewOutlet;
}

@end

@implementation HistoryViewController

@synthesize managedObjectContext;

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
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    [super viewDidLoad];
    self.title = @"History";
    
    historyArray = [self allEntitiesNamed:@"Business"];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"History";

    [historyTableViewOutlet reloadData];
}

#pragma mark -- table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * currentCell;    
    currentCell = [tableView dequeueReusableCellWithIdentifier:@"HistoryReuseIdentifier"];
	
	if(currentCell == nil)
    {
        currentCell = [[UITableViewCell alloc]
                       initWithStyle:UITableViewCellStyleSubtitle
                       reuseIdentifier:@"HistoryReuseIdentifier"];
        currentCell.accessoryType =     UITableViewCellAccessoryDisclosureIndicator;
	}
    
    Business *currentBusiness = [historyArray objectAtIndex:[indexPath row] ];
	currentCell.textLabel.text = currentBusiness.name;
    currentCell.detailTextLabel.text = currentBusiness.phone;
	return currentCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //The following occurs when you swipe to delete and hit delete.
        //Put code here to delete the object from the managedObjectContext..............
        
        Business *business = [historyArray objectAtIndex:indexPath.row];
        
        [managedObjectContext deleteObject:business];
        
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            //NSLog(@"Add bookmark status failed.");
        }
        
        historyArray = [self fetchBookmarks];
        
        [tableView reloadData];    }
}

//core data fetch
-(NSArray *)allEntitiesNamed:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"viewDate" ascending:NO];
    NSArray * sortDescriptorArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    fetchRequest.entity = entity;
    [fetchRequest setSortDescriptors:sortDescriptorArray];

    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//core data fetch for bookmarked businesses
-(NSArray*) fetchBookmarks
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController * fetchResultsController;
    
    //Now customize your search! We'd want to switch this to see if isBookmarked == true
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"viewDate" ascending:YES];
    NSArray * sortDescriptorArray = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isBookmarked == %@", [NSNumber numberWithBool:YES]];
    NSError *searchError;
    
    //David's Predicate Format Notes: may be deleted with impunity......................................
    //    NSPredicate *newPredicate = [NSPredicate predicateWithFormat:@"anAttribute == %@",[NSNumber numberWithBool:aBool]];
    //    NSPredicate *testForTrue = [NSPredicate predicateWithFormat:@"anAttribute == YES"];
    //.............................................................................................
    
    //Lock and load
    [fetchRequest setSortDescriptors:sortDescriptorArray];
    [fetchRequest setEntity:entityDescription];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [fetchResultsController performFetch:&searchError];
    bookmarkArray = fetchResultsController.fetchedObjects;
    
    return fetchResultsController.fetchedObjects;
}

//Delete an object from the History.
-(void)deleteVenue: (Venue*)venue
{
    NSError *error;
    {
        NSLog(@"Delete History item method failed: %@", error);
    }
}

#pragma mark -- segue methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YelpWebPageBrowser * ywpb = [segue destinationViewController];

    NSIndexPath *path = historyTableViewOutlet.indexPathForSelectedRow;
    Business *businessForSegue = [historyArray objectAtIndex:path.row];
    ywpb.yelpURLString = [[historyArray objectAtIndex:path.row] yelpURLString];
    ywpb.name = businessForSegue.name;
    ywpb.longitude = businessForSegue.longitude;
    ywpb.latitude = businessForSegue.latitude;
    ywpb.phone = businessForSegue.phone;
    ywpb.viewDate = businessForSegue.viewDate;
}

#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
