//
//  ShowDetailPic.m
//  yande.re
//  显示流程，加载图片，同时加载偏好文件，匹配id与偏好，如不存在则显示收藏按钮为unlike，反之显示为like，点击后移除偏好文件对应内容，同步写入偏好文件，同时反置按钮状态
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "ShowDetailPic.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>

#define LikeListFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/LikeList.plist"]
#define BlackListFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/BlackList.plist"]

@implementation ShowDetailPic
@synthesize param;
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initImage];
    [self addDownload];
    Preference=[[PreferenceModule alloc] init];
    [self LoadImage];
    UISwipeGestureRecognizer *swipeleft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [_ImageView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleswpieright:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [_ImageView addGestureRecognizer:swiperight];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLayout) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(Pinched:)];
    
}
-(void)initImage
{
    _scrollview.contentSize=_scrollview.bounds.size;
    _ImageView.frame=_scrollview.bounds;
    _scrollview.maximumZoomScale=2.0;
    _scrollview.minimumZoomScale=0.5;
    
}
-(void)addDownload
{
    download=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStyleDone target:self action:@selector(DownLoad)];
    download.enabled=NO;
}
-(void)ChangeLayout
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        _ImageView.frame=_scrollview.bounds;
    }
}
-(void)LoadImage
{
    isLiked=[Preference isPostLiked:param];
    [self initUI];
    MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在加载:0%";
    _ImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_ImageView sd_setImageWithURL:[param valueForKey:@"sample_url"] placeholderImage:_placeholder options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在加载:%.1f%@",task*100,@"%"];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        download.enabled=YES;
    }];
}
-(void)initUI
{
    NSString *name=[[NSString alloc] init];
    if(isLiked)
        name=@"like";
    else
        name=@"unlike";
    like=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:name] style:UIBarButtonItemStyleDone target:self action:@selector(AddFavourite)];
    if(isLiked)
        like.tintColor=[UIColor redColor];
    self.navigationItem.rightBarButtonItems=@[like,download];
}

-(void)DownLoad
{
     UIImageWriteToSavedPhotosAlbum(_ImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *hud=[[MBProgressHUD alloc ]initWithView:self.view];
    hud.mode=MBProgressHUDModeText;
    [self.view addSubview:hud];
    if (!error) {
        hud.labelText=@"保存成功";
    }else
    {
        hud.labelText=@"保存失败";
    }
    
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}
-(void)AddFavourite
{
    if(isLiked)
        [Preference RemovePostLiked:param];
    else
        [Preference AddPostLiked:param];
    isLiked=[Preference isPostLiked:param];
    [self initUI];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"切换左");
}
-(void)handleswpieright:(UISwipeGestureRecognizer *)recognizer;
{
    
}

-(void)Pinched:(UIPinchGestureRecognizer *)sender
{
}

-(void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
-(void)didReceiveMemoryWarning
{
}
@end
