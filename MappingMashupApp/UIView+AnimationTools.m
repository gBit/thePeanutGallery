//
//  UIView+AnimationTools.m
//  MappingMashupApp
//
//  Created by StopBitingMe on 3/24/13.
//  Copyright (c) 2013 The Peanut Gallery. All rights reserved.
//

#import "UIView+AnimationTools.h"

@implementation UIView (AnimationTools)

-(void)squishImage
{
    [UIView animateWithDuration:0.1
                     animations:^void(void)
                     {
                         self.transform = CGAffineTransformMakeScale(1.3, 1.3);
                     }
                     completion:^void(BOOL finished)
                     {
                         self.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

-(void)fanLeft
{
    
}

-(void)fanUp
{
    
}

-(void)fanRight
{
    
}

@end
