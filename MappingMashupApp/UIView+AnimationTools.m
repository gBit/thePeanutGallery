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

-(void)lowerImageView
{
    
    [UIView animateWithDuration:0.5
                     animations:^void(void)
                     {
                         self.center = CGPointMake(self.center.x, self.frame.size.height/2 + 10);
                         //self.alpha = 0.90;
                     }];
}

-(void)raiseImageView
{
    [UIView animateWithDuration:0.5
                     animations:^void(void)
                     {
                         self.center = CGPointMake(self.center.x, self.center.y - self.frame.size.height * 1.5 - 10);
                         //self.alpha = 0.90;
                     }];
}
@end
