//
//  YelpWebPageBrowser.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/17/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "YelpWebPageBrowser.h"

@interface YelpWebPageBrowser ()
{
    
    __weak IBOutlet UIView *popoutView;
    __weak IBOutlet UILabel *popoutViewTextLabel;
    __weak IBOutlet UIWebView *webView;
}
- (IBAction)swipeRightAction:(id)sender;
- (IBAction)swipeLeftAction:(id)sender;

@end

@implementation YelpWebPageBrowser

@synthesize yelpURLString;

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
    
    //Adds bookmark button to top right corner
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookmark)];
    //Enable button just in case
    [self.navigationItem.rightBarButtonItem setEnabled:YES];

    //Load yelp page
    NSString *homePage = [NSString stringWithFormat:@"%@", yelpURLString];
    NSURL * url = [NSURL URLWithString:homePage];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
	[webView loadRequest: urlRequest];
    
    //Scroll off "swipe to navigate" message after 1.5 seconds
    //Hold for 1.5 seconds, then scroll off left side.
    [UIView animateWithDuration:1.5 animations:^(void)
        {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5 animations:
                          ^{popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y-100);}
                          ];
                                                }
    ];
     
}

-(void) addBookmark
{
    
    //Include code here that will add the current Yelp business as a bookmark
    //Come back to this once Core Data implementation is complete.
    
    //Tell user that bookmark has been added
    popoutViewTextLabel.text = @"Bookmark added";
    //Scroll on, pause for 1.5 seconds, scroll off
    [UIView animateWithDuration:0.5 animations:^(void)
     {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y+100);}
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.5 animations:^(void)
                          {popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.5 animations:
                                               ^{popoutView.center = CGPointMake(popoutView.center.x, popoutView.center.y-100);}
                                               ];
                                          }
                          ];                     }
     ];
    //Disable button so they can't bookmark the same page again.
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
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
