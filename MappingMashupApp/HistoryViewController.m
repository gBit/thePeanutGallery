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








#pragma mark -- end of document
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
