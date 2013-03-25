//
//  YelpWebPageBrowser.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/17/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "YelpWebPageBrowser.h"
#import "Business.h"
#import "AppDelegate.h"
#import "NSString+Extended.h"
#import "BookmarkedBusiness.h"

@interface YelpWebPageBrowser ()
{
    
    __weak IBOutlet UIView *popoutView;
    __weak IBOutlet UILabel *popoutViewTextLabel;
    __weak IBOutlet UIWebView *webView;
    Business *currentBusiness;
    
    
}
- (IBAction)swipeRightAction:(id)sender;
- (IBAction)swipeLeftAction:(id)sender;

@end

@implementation YelpWebPageBrowser

@synthesize yelpURLString,managedObjectContext, name, latitude, longitude, phone, viewDate;




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
    //Custom formatting for navigation bar
    
    // Core Data
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    currentBusiness = [self fetchBusinessShownInWebpage];
    
    //Adds bookmark button to top right corner
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
    
    //Enable button just in case
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    
    //Check to see if this venue is already bookmarked
//    if (venue.isBookmarked == YES)
//    {
//        NSLog(@"Page already bookmarked");
//        [self.navigationItem.rightBarButtonItem setEnabled:NO];
//    }


    //Load yelp page
    NSString *homePage = [NSString stringWithFormat:@"%@", yelpURLString];
    NSURL * url = [NSURL URLWithString:homePage];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
	[webView loadRequest: urlRequest];
    
    //Scroll off "swipe to navigate" message after 1.5 seconds
    //Hold for 1.5 seconds, then scroll off left side.
//    [UIView animateWithDuration:1.0 animations:^(void)
//        {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y-10);}
//                     completion:^(BOOL finished){
//                         [UIView animateWithDuration:2.5 animations:
//                          ^{popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y+200);
//                              popoutView.alpha = 0;
//                          }
//                          ];
//                                                }
//    ];
    
    [UIView animateWithDuration:0.75
                          delay:3.0
                        options: UIViewAnimationCurveEaseIn
                     animations:^{
                         popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y+200);
                         popoutView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                     }];

    
    
    
    //End of method bracket
}



-(void) addBookmark
{
    
    //this code will change the bookmark attribute on the currentbusiness "Business" class object
    //AND create a new "BoomarkedBusiness" class object with the same attributes, so that it may persist even if removed from the history list
    
    currentBusiness.isBookmarked = [NSNumber numberWithBool:YES];
    
    BookmarkedBusiness *businessToBookmark = [NSEntityDescription insertNewObjectForEntityForName:@"BookmarkedBusiness" inManagedObjectContext:managedObjectContext];
    
    
    businessToBookmark.name = name;
    businessToBookmark.phone = phone;
    businessToBookmark.latitude = latitude;
    businessToBookmark.longitude = longitude;
    businessToBookmark.yelpURLString = yelpURLString;
    businessToBookmark.viewDate = viewDate;
    businessToBookmark.isBookmarked = [NSNumber numberWithBool:YES];
    
    NSError *error;
    if (![managedObjectContext save:&error])
    {
        NSLog(@"failed to save: %@", [error userInfo]);
    }
    
    
    popoutViewTextLabel.text = @"Bookmark added";
    //Scroll on, pause for 1.5 seconds, scroll off
    [UIView animateWithDuration:0.5 animations:^(void)
     {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y-201);
         popoutView.alpha = 0.90;}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.25 animations:^(void)
                          {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y);
                              popoutView.alpha = 1;}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5 animations:
                                               ^{popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y+200);
                                                   popoutView.alpha = 0;}
                                               ];
                                          }
                          ];
                     }
     ];
    
    //Disable button so they can't bookmark the same page again.
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

//Add to bookmarks.
-(void)addBookmarkStatusTo: (Business*)business
{

    //venue.isBookmarked = YES;
    NSError *error;
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Add bookmark status failed.");
    }
    
    
    
    
    
    
}


//fetch the managed object of the business we're looking at in this webView

-(Business*) fetchBusinessShownInWebpage
{
    NSArray *businessesArray;
    Business *business;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Business" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController * fetchResultsController;
    
    NSString *predicateURLString = [yelpURLString urlencode];
    //Now customize your search! We'd want to switch this to see if isBookmarked == true
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"yelpURLString == '%@'", yelpURLString]];
    NSError *searchError;

    //Lock and load
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDescription];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [fetchResultsController performFetch:&searchError];
    //Something about making the arrays equal size or some shit. Gawd.
    //This will update your display array with your fetch results
    
    
    businessesArray = fetchResultsController.fetchedObjects;
    
    if (businessesArray != nil && businessesArray.count > 0) {
        business = [businessesArray objectAtIndex:0];
    }
    
    
    return business;
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Swipe gestures to go forwards, back
- (IBAction)swipeLeftAction:(id)sender {
    [webView goForward];
}

- (IBAction)swipeRightAction:(id)sender {
    [webView goBack];

}


@end
