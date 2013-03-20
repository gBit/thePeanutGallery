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
    
    //Load yelp page
    NSString *homePage = [NSString stringWithFormat:@"%@", yelpURLString];
    NSURL * url = [NSURL URLWithString:homePage];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
	[webView loadRequest: urlRequest];
}

-(void) addBookmark
{
    //Include code here that will add the current Yelp business as a bookmark
    //Come back to this once Core Data implementation is complete.
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
