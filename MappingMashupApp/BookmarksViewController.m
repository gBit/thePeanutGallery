//
//  BookmarksViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/20/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "BookmarksViewController.h"
#import "AppDelegate.h"
#import "Business.h"
#import "BookmarkedBusiness.h"

@interface BookmarksViewController ()
{
    NSArray * testBookmarks;
    NSArray *bookmarkArray;
}
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

@implementation BookmarksViewController

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
//Add title field to navigation bar
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    bookmarkArray = [self allEntitiesNamed:@"BookmarkedBusiness"];
    //self.navigationItem.title = [[UIBarButtonItem alloc] init];

    self.navigationItem.title = @"Bookmarks";
    
    //Working code starst here - placemarker array
    testBookmarks = [[NSArray alloc] initWithObjects:@"First Bookmark", @"Second Bookmark", @"Third Bookmark", nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //............
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //The following occurs when you swipe to delete and hit delete.
        //Put code here to delete the object from the managedObjectContext..............
        
        BookmarkedBusiness *bookmarkedBusiness = [bookmarkArray objectAtIndex:indexPath.row];
        //business.isBookmarked = [NSNumber numberWithBool:NO];
        
        [self.managedObjectContext deleteObject:bookmarkedBusiness];
        
        NSError *error;
        if (![self.managedObjectContext save:&error])
        {
            //NSLog(@"Add bookmark status failed.");
        }
        
        bookmarkArray = [self allEntitiesNamed:@"BookmarkedBusiness"];
        
        
        //bookmarkArray = [self fetchBookmarks];
        
        [tableView reloadData];
        //[self removeBookmarkStatusFrom:business]
    
    
        
    //old delete bookmark code......
    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        
//        
//        Business *business = [bookmarkArray objectAtIndex:indexPath.row];
//        business.isBookmarked = [NSNumber numberWithBool:NO];
//        
//        NSError *error;
//        if (![self.managedObjectContext save:&error])
//        {
//            //NSLog(@"Add bookmark status failed.");
//        }
//        
//        bookmarkArray = [self allEntitiesNamed:@"BookmarkedBusiness"];
//        
//        [tableView reloadData];
        //[self removeBookmarkStatusFrom:business]
    }
}

//Remove from bookmarks, but do not remove from history.
-(void)removeBookmarkStatusFrom: (Business*)business
{
    business.isBookmarked = [NSNumber numberWithBool:NO];
}
#pragma mark -- table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return bookmarkArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. declare a cell
    UITableViewCell * currentCell;
    
    //2. see if there are any cells we can reuse
    currentCell = [tableView dequeueReusableCellWithIdentifier:@"BookmarkReuseIdentifier"];
	
    //3. if not, create one to use!
	if(currentCell == nil)
    {
        currentCell = [[UITableViewCell alloc]
                       initWithStyle:UITableViewCellStyleSubtitle
                       reuseIdentifier:@"BookmarkReuseIdentifier"];
        currentCell.accessoryType =     UITableViewCellAccessoryDisclosureIndicator;
	}
	//4. change the textLabel to reflect the data we are using.
    Business *currentBusiness = [bookmarkArray objectAtIndex:[indexPath row]];
    
	currentCell.textLabel.text = currentBusiness.name;
    currentCell.detailTextLabel.text = currentBusiness.phone;
	return currentCell;
    
}

//core data fetch for bookmarked businesses SWITCHED OFF AT THE MOMENT
//-(NSArray*) fetchBookmarks
//{
//    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:self.managedObjectContext];
//    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
//    NSFetchedResultsController * fetchResultsController;
//    
//    //Now customize your search! We'd want to switch this to see if isBookmarked == true
//    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:nil];
//    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"isBookmarked == %@", [NSNumber numberWithBool:YES]];
//    NSError *searchError;
//    
//
//    
//    //Lock and load
//    [fetchRequest setSortDescriptors:sortDescriptors];
//    [fetchRequest setPredicate:predicate];
//    [fetchRequest setEntity:entityDescription];
//    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
//    
//    [fetchResultsController performFetch:&searchError];
//    //Something about making the arrays equal size or some shit. Gawd.
//    //This will update your display array with your fetch results
//    bookmarkArray = fetchResultsController.fetchedObjects;
//    
//    
//    return fetchResultsController.fetchedObjects;
//    
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self performSegueWithIdentifier:@"bookmarkToWebView" sender:self];
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}

#pragma mark -- segue methods
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    YelpWebPageBrowser * ywpb = [segue destinationViewController];
    //Future Ross, this might break
    //ywpb.yelpURLString = selectedAnnotation.yelpPageURL;
    ywpb.yelpURLString = @"http://m.yelp.com";
    //Also, here, pass the Business (managed object) that is saved here to the webPageBrowser.
}

-(NSArray *)allEntitiesNamed:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    NSError *error;
    
    fetchRequest.entity = entity;
    
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
}





#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
