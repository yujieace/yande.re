//
//  FavouriteViewController.m
//  yande.re
//
//  Created by 於杰 on 16/4/27.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "FavouriteViewController.h"

@implementation FavouriteViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    _slide.baseViewController=self;
    _slide.delegate=self;
    _slide.tabItemNormalColor=[UIColor grayColor];
    _slide.tabItemSelectedColor=[UIColor colorWithRed:(CGFloat)246/255.0 green:(CGFloat)103/255.0 blue:(CGFloat)79/255.0 alpha:1];
    _slide.tabbarTrackColor=[UIColor colorWithRed:(CGFloat)246/255.0 green:(CGFloat)103/255.0 blue:(CGFloat)79/255.0 alpha:1];
    _slide.tabbarBottomSpacing=3.0;
    DLTabedbarItem *item1=[DLTabedbarItem itemWithTitle:@"图片收藏" image:[UIImage imageNamed:@"bar"] selectedImage:[UIImage imageNamed:@"bar"]];
    DLTabedbarItem *item2=[DLTabedbarItem itemWithTitle:@"图集收藏" image:[UIImage imageNamed:@"bar"] selectedImage:[UIImage imageNamed:@"bar"]];
    NSArray *items=[[NSArray alloc] initWithObjects:item1,item2, nil];
    _slide.tabbarItems=items;
    [_slide buildTabbar];
    _slide.selectedIndex=0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLayout) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender
{
    return 2;
}

-(UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"FavouritePost"];
            return dest;
        }
            break;
        case 1:
        {
            UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"FavouritePool"];
            return dest;
        }break;
        default:
            break;
    }
    return nil;
}

/*
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _slide.frame=self.view.bounds;
    }
    
}*/

-(void)ChangeLayout
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _slide.frame=self.view.bounds;
    }
}
-(void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
@end
