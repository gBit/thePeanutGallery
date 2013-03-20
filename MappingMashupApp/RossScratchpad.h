//
//  RossScratchpad.h
//  MappingMashupApp
//
//  Created by Ross Matsuda on 3/20/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

//This class is only used to hold code snippets to be integrated later

#ifndef MappingMashupApp_RossScratchpad_h
#define MappingMashupApp_RossScratchpad_h

//Method to add that will create a mask
- (UIImage*) createMaskWith: (UIImage *)maskImage onImage:(UIImage*) subjectImage
{
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef),
                                        NULL,
                                        false);
    
    CGImageRef masked = CGImageCreateWithMask(subjectImage.CGImage, mask);
    
    UIImage *finalImage = [UIImage imageWithCGImage:masked];
}

//Code to add to set an annotation to a masked version of that picture

//First, get the image URL converted to an image

NSURL *flickrThumbnailURL = [NSURL URLWithString:flickrThumbnailURLString];
//making the request online for the photo
NSData *photoData = [NSData dataWithContentsOfURL:flickrThumbnailURL];
UIImage *photoThumbnailImage = [UIImage imageWithData:photoData];

//The first line needs to be changed to take in a particular annotation's thumbnail from URL.
myAnnotation.image = [UIImage imageNamed:[UIImage imagewithContentsOfURL: flickrThumbnailURL]];
UIImage * mask = [UIImage imageNamed:@"circleMask6464.png"];
UIImage *maskedAnnotationImage = [self createMaskWith:mask onImage:photoThumbnailImage];
//This line needs to be changed to verify that the UIImageView we init with that image is the one the annotation is in.
//One of the two following lines should work - we probably don't need to drop it inside an imageView, and can go straight to putting the masked image in the annotationView.
myImageView = [[UIImageView alloc] initWithImage:maskedAnnotationImage];
myAnnotation.image = maskedAnnotationImage;

------------------------------------------------------------------------
Fetch requests for bookmarks and history

To manually call a segue, add this method to bookmarkButtonPressed method
[self performSegueWithIdentifier: @”toBookmarksAndHistory” sender:self]

//Do we need to instantiate our lists before we begin?
MMAppDelegate *mmAppDelegate = (MMAppDelegate*)[[UIApplication sharedApplication] delegate];
self.myManagedObjectContext = mmAppDelegate.managedObjectContext;
//Instantiate your freak and geek lists
geek = [NSEntityDescription insertNewObjectForEntityForName: @"Geek" inManagedObjectContext: self.myManagedObjectContext];
freak = [NSEntityDescription insertNewObjectForEntityForName: @"Freak" inManagedObjectContext: self.myManagedObjectContext];





//A sample fetch request
//To enter the basic fetch request (automated)
-(NSArray *)allEntitiesNamed:(NSString *)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.myManagedObjectContext];
    NSError *error;
    
    fetchRequest.entity = entity;
    
    return [self.myManagedObjectContext executeFetchRequest:fetchRequest error:&error];
}

//Another chunk from that project - 
//Fetch request
-(NSArray*) getCurrentSpies
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.myManagedObjectContext];
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc]init];
    NSFetchedResultsController * fetchResultsController;
    
    //Now customize your search! We'd want to switch this to see if isBookmarked == true
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:nil];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name contains[c] '%@'", mySearchText]];
    NSError *searchError;
    
    if ([mySearchText isEqualToString:@""])
    {
        predicate = nil;
    }
    
    //Lock and load
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:entityDescription];
    fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.myManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [fetchResultsController performFetch:&searchError];
    //Something about making the arrays equal size or some shit. Gawd.
    //This will update your display array with your fetch results
    displaySpies = fetchResultsController.fetchedObjects;
    
    
    return fetchResultsController.fetchedObjects;
    
}


//Delete an object from the History.
-(void)deletePerson: (Person*)person
{
    [self.myManagedObjectContext deleteObject:person];
    NSError *error;
    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Delete History item method failed.");
    }
}

//Remove from bookmarks, but do not remove from history.
-(void)removeBookmarkStatusFrom: (Venue*)venue 
{
    venue.isBookmarked = NO;
    NSError *error;
    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Remove bookmark status failed.");
    }
}

//Add to bookmarks.
-(void)addBookmarkStatusFrom: (Venue*)venue
{
    venue.isBookmarked = YES;
    NSError *error;
    if (![self.myManagedObjectContext save:&error])
    {
        NSLog(@"Add bookmark status failed.");
    }
}

#endif
