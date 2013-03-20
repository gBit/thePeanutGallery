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


#endif
