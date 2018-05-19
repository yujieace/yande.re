//
//  ADImageViewController.m
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 hnzc. All rights reserved.
//

#import "ADImageViewController.h"
#import "PreferenceModule.h"
#import "ViewController+Message.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "PreferenceModule.h"
#import <FTPopOverMenu.h>
#import "DownloadManager.h"
#import "ImageSaveDelegate.h"

@interface ADImageViewController ()<MWPhotoBrowserDelegate>
{
    BOOL isLiked;
    PreferenceModule *Preference;
    NSUInteger currentIndex;
}
@end

@implementation ADImageViewController

-(instancetype)init
{
    self = [super init];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    Preference=[[PreferenceModule alloc] init];
    [super setDelegate:self];
    
    [self reloadData];
    [self setCurrentPhotoIndex:currentIndex];
    [self initMenuBarItem];
}
-(void)setCurrentPhotoIndex:(NSUInteger)index{
    currentIndex=index;
    [super setCurrentPhotoIndex:index];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
}
-(void)initMenuBarItem{
    UIBarButtonItem *menu=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleDone target:self action:@selector(showPopMenu:event:)];
    self.navigationItem.rightBarButtonItems=@[menu];
}

-(void)showPopMenu:(UIBarButtonItem *)sender event:(UIEvent *)event{
    [FTPopOverMenu showFromEvent:event withMenuArray:@[@"下载",isLiked?@"取消收藏":@"收藏"] imageArray:@[@"download",isLiked?@"like":@"unlike"] doneBlock:^(NSInteger selectedIndex) {
        switch (selectedIndex) {
            case 0:
            {
                [self DownLoad];
            }
                break;
            case 1:{
                if(isLiked){
                    [Preference RemovePostLiked:self.imageList[self.currentIndex]];
                    isLiked = NO;
                }else{
                    [Preference AddPostLiked:self.imageList[self.currentIndex]];
                    isLiked = YES;
                }
                
            }
                
            default:
                break;
        }
    } dismissBlock:nil];
}




-(void)DownLoad
{
    NSDictionary *param = self.imageList[self.currentIndex];
    NSURL *url =[NSURL URLWithString:param[@"jpeg_url"]];
    DownloadTask *task = [[DownloadTask alloc] init];
    task.delegate=[ImageSaveDelegate sharedInstance];
    task.url=url;
    [[DownloadManager sharedInstance] addTask:task];

}



- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.imageList.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSDictionary *temp = _imageList[index];
    MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:temp[@"sample_url"]]];
    return photo;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    NSDictionary *temp = _imageList[index];
    isLiked = [Preference isPostLiked:temp];
}

@end
