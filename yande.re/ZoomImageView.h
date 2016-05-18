//
//  ZoomImageView.h
//  yande.re
//
//  Created by hnzc on 16/5/13.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomImageView : UIView<UIScrollViewDelegate>
{
    UIScrollView *contentView;
}
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) UIImageView *imageView;
-(void)setImage:(UIImage *)image;
-(instancetype)init;
-(instancetype)initWithFrame:(CGRect)frame;
@end
