//
//  PinchImageView.h
//  yande.re
//
//  Created by hnzc on 16/5/13.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PinchImageView : UIImageView
{
    UIPinchGestureRecognizer *pinch;
    CGAffineTransform currentTransform;
    CGFloat lastPhotoScale;
}

-(void)addPinch;
@end
