//
//  UIView+Shadow.m
//  Sanya University
//
//  Created by 於杰 on 16/3/1.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView(UIview_Shadow)
-(void)AddShadow
{
    UIBezierPath *path=[UIBezierPath bezierPathWithRect:self.bounds];
    self.layer.masksToBounds=NO;
    self.layer.shadowColor=[UIColor grayColor].CGColor;
    self.layer.shadowOffset=CGSizeMake(5.0f, 5.0f);
    self.layer.shadowOpacity=1.0f;
    self.layer.shadowPath=path.CGPath;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
