//
//  ZoomImageView.m
//  yande.re
//
//  Created by hnzc on 16/5/13.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "ZoomImageView.h"
#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)
@implementation ZoomImageView

/**
 *  默认初始化方法
 *
 *  @return ZoomImageView
 */
-(instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}

/**
 *  初始化方法
 *
 *  @param frame 位置、大小
 *
 *  @return ZoomImageView
 */
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    contentView=[[UIScrollView alloc] initWithFrame:frame];
    contentView.contentSize=frame.size;
    contentView.delegate=self;
    _imageView=[[UIImageView alloc] initWithFrame:frame];
    [_imageView setUserInteractionEnabled:YES];
    [_imageView setMultipleTouchEnabled:YES];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHandler:)];
    tap.numberOfTapsRequired=2;
    [_imageView addGestureRecognizer:tap];
    
    [contentView addSubview:_imageView];
    [self addSubview:contentView];
    return self;
}
-(void)setImage:(UIImage *)image
{
    _image=image;
    _imageView.image=_image;
}

/************实现缩放手势************/

-(void)TapHandler:(UITapGestureRecognizer *)guesture
{
    float newScale=contentView.zoomScale*1.5;
    CGRect rect=[self zoomRectForScale:newScale withCenter:[guesture locationInView:_imageView]];
    [contentView zoomToRect:rect animated:YES];
}
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = contentView.frame.size.height / scale;
    zoomRect.size.width  = contentView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}
/************实现双击放大手势********/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
