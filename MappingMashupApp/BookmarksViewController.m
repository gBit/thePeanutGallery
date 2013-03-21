//
//  BookmarksViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/20/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "BookmarksViewController.h"

@interface BookmarksViewController ()
{
    NSArray * testBookmarks;
}

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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
     //   [self removeBookmarkStatusFrom:<#(Venue *)#>];
    }
}

//Remove from bookmarks, but do not remove from history.
-(void)removeBookmarkStatusFrom: (Venue*)venue
{
    //venue.isBookmarked = NO;
    NSError *error;
    //if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Add bookmark status failed.");
    }
}
#pragma mark -- table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return testBookmarks.count;
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
    
	currentCell.textLabel.text = [testBookmarks objectAtIndex:[indexPath row]];
    currentCell.detailTextLabel.text = @"Test Subtitle";
	return currentCell;
    
}

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

#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
