//
//  PinchImageView.m
//  yande.re
//
//  Created by hnzc on 16/5/13.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "PinchImageView.h"

@implementation PinchImageView
-(void)addPinch
{
    pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(Pinched:)];
    [self setMultipleTouchEnabled:YES];
    [self setUserInteractionEnabled:YES];
    [self addGestureRecognizer:pinch];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}
-(void)Pinched:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        
        currentTransform =self.transform;
        
    }
    
    if (gesture.state ==UIGestureRecognizerStateChanged) {
        
        CGAffineTransform tr =CGAffineTransformScale(currentTransform, gesture.scale, gesture.scale);
        
        self.transform = tr;
        
        self.frame =CGRectMake(0,0, self.frame.size.width,self.frame.size.height);
        
    }
    
    if ((gesture.state ==UIGestureRecognizerStateEnded) || (gesture.state ==UIGestureRecognizerStateCancelled)) {
        lastPhotoScale =lastPhotoScale*gesture.scale;
        
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
