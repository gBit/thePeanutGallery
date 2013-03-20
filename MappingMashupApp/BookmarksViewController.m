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
    testBookmarks = [[NSArray alloc] initWithObjects:@"First Bookmark", @"Second Bookmark", @"Third Bookmark", nil];
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
    [self performSegueWithIdentifier:@"bookmarkToWebView" sender:self];
    [tableView deselectRowAtIndexPath: indexPath animated:YES];
    
}



#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
