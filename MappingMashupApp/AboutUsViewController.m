//
//  AboutUsViewController.m
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/27/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
{
    __weak IBOutlet UIButton *rossPeanut;
    __weak IBOutlet UIButton *paulPeanut;
    __weak IBOutlet UIButton *emilyPeanut;
    __weak IBOutlet UIButton *davidPeanut;
    __weak IBOutlet UITextView *aboutTextField;
}
- (IBAction)davidPeanutTapped:(id)sender;
- (IBAction)emilyPeanutTapped:(id)sender;
- (IBAction)paulPeanutTapped:(id)sender;
- (IBAction)rossPeanutTapped:(id)sender;

@end

@implementation AboutUsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)davidPeanutTapped:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^(void){ davidPeanut.center = CGPointMake(davidPeanut.center.x, 88);rossPeanut.center = CGPointMake(rossPeanut.center.x, 45); emilyPeanut.center = CGPointMake(emilyPeanut.center.x, 45); paulPeanut.center = CGPointMake(paulPeanut.center.x, 45);} completion:^(BOOL finished) {
        aboutTextField.text = @"David Johnston \n \nYou mustn't hate you're how you dress \nin plastic pants and false finess \nif helps it fill your emptiness. \n \nAnd cringe I not you phone your shrink \nwith cries of dump you in the drink; \njust roll you up in royal mink \n \nand seek a spot off somewhere back \nso silent sweet and softly black \nto there your torrid worry stack \n \nand rest yourself. \nThings will work out.";
    }];
}

- (IBAction)emilyPeanutTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void){ davidPeanut.center = CGPointMake(davidPeanut.center.x, 42);rossPeanut.center = CGPointMake(rossPeanut.center.x, 45); emilyPeanut.center = CGPointMake(emilyPeanut.center.x, 85); paulPeanut.center = CGPointMake(paulPeanut.center.x, 45);} completion:^(BOOL finished) {
        aboutTextField.text = @"Emily Oess\n\n-|gBit@eOS|~| |:)\n-$ zonnet\n\nChicago-Brown Line Station\nYou are at the end of an el platform in an urban environment west of a big blue lake. A turnstile leads to a set of stairs. In the distance, you can see that the stairs will eventually fork off. The buildings here are very tall concrete buildings, and they are spaced (relatively) equidistant from each other. There is a girl here.\n> look girl\nThe girl appears pretty normal from the outside, but if superhero movies have taught you anything it's that masked avengers frequently look super ordinary in broad daylight because that's obviously how you conceal your identity. No, sir. Because while this girl may enjoys long walks on the beach, she also digs refactoring code. And then you realize you're talking to yourself.\n> look\nYou are still on the el platform. Looking at the clock on your iPhone, you notice another train has arrived and you have no idea exactly how long you've been standing here wrapped up in meta-cognition. Better get going or you're going to be late, yo.\n> down\nN Franklin/W Superior Intersection\nYou are at an intersection of two streets, one running north/south, and one running east/west. You can also go back up the stairs.\n> south\nN Franklin/W Huron Intersection\nYou are on the continuation of a city street. There are more buildings on both sides of you. The roads continue north/south and east/west.\n> s\nN Franklin/W Erie Intersection\nYou are STILL on the continuation of a city street. In the distance you can see that it will eventually hit a river. You notice The Mobile Makers building to the southeast.\n> se\nBuilding front\nThere is a building in front of you to the south, and the road leads back to the east/west.\n> in\nYou don't have a key that can open this door. Luckily, a group of people walk up and go in.\n> tailgate\nLobby\nYou are in the building lobby. There are stairs and an elevator here. Your spidey sense kicks in and you realize there is another nerd in close proximity.\n> talk to nerd\nYou attempt to talk to the nerd, but cannot hear his response because you've been rockin' out to some mad beats.\n> take out earbuds\nYou take out your headphones and start a conversation that makes everyone around take a step back. They obviously fear catching the nerditude.\n> turn up volume\nDone. Bring the noise.";
    }];
}

- (IBAction)paulPeanutTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void){ davidPeanut.center = CGPointMake(davidPeanut.center.x, 42);rossPeanut.center = CGPointMake(rossPeanut.center.x, 45); emilyPeanut.center = CGPointMake(emilyPeanut.center.x, 45); paulPeanut.center = CGPointMake(paulPeanut.center.x, 85);} completion:^(BOOL finished) {
        aboutTextField.text = @"Paul Heayn \n \nDuring the cold war, Paul escaped into West Germany where he established himself as a merchant of freedom. Through daring plans of stealth, Paul managed to liberate 3,642 East Germans. \n  \nAfter the end of the Cold War, Paul migrated to the island of Krakatoa where he helped the native people engineer Cold Fusion and a Monorail. Unfortunately, in a tragic series of events the Monorail derailed into the Cold Fusion plant, thereby destroying the world's first plant capable of generating nuclear energy without radioactive byproduct.\n \nPaul fled Krakatoa after 'The Incident' to Riverside, Iowa where he purchased a soy bean farm and blended in as a townsman. Unfortunately, during the pope's visit to Riverside, Paul mistakenly got into a slap fight with Pope John Paul II.\n \nOnce again, Paul was forced to leave. Living a nomadic life of adventure Paul walked through the Americas only to end up at The Mobile Makers for the Winter 2013 class.";
    }];
}

- (IBAction)rossPeanutTapped:(id)sender {
    [UIView animateWithDuration:0.5 animations:^(void){ davidPeanut.center = CGPointMake(davidPeanut.center.x, 42);rossPeanut.center = CGPointMake(rossPeanut.center.x, 85); emilyPeanut.center = CGPointMake(emilyPeanut.center.x, 45); paulPeanut.center = CGPointMake(paulPeanut.center.x, 45);} completion:^(BOOL finished) {
        aboutTextField.text = @"Ross Matsuda \n \nRoss Matsuda has a background in graphic design, psychology, tech support and theatrical directing. He's a proud graduate of MobileMakers and will be continuing with his career in mobile application development, graphic design and user experience. When it is contextually appropriate, he speaks in the third person to maintain a professional tone - to this day, he can't fully understand why that is. He wants to spend his life figuring out things that people need before they know they need them. He doesn't need to change the world with each project he works on, but at least wants to raise the bar. Here's to more years of innovation, yes?";
    }];
}
@end
