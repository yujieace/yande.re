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
#import <Social/Social.h>
#import "ViewController+Message.h"
#import "ViewController+Share.h"
#define LikeListFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/LikeList.plist"]
#define BlackListFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/BlackList.plist"]

@implementation ShowDetailPic
@synthesize param;
-(void)viewDidLoad
{
    [super viewDidLoad];
    currentIndex=[_index integerValue];
    [self initImageView];
    [self initGuesture];
    [self addDownload];
    Preference=[[PreferenceModule alloc] init];
    [self LoadImage];
    self.navigationController.hidesBarsOnTap=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLayout) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];

}

-(void)initImageView
{
    _ImageView=[[UIImageView alloc] init];
    _ImageView.multipleTouchEnabled=YES;
    _ImageView.userInteractionEnabled=YES;
    [self.view addSubview:_ImageView];
}

-(void)initGuesture
{
    UISwipeGestureRecognizer *swipeleft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [_ImageView addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleswpieright:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [_ImageView addGestureRecognizer:swiperight];
    
    UIPinchGestureRecognizer *pinch=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(Pinched:)];
    [_ImageView addGestureRecognizer:pinch];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor=[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
       _ImageView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _ImageView.center=self.view.center;
    NSLog(@"%f,%f,%f,%f",_ImageView.center.x,_ImageView.center.y,self.view.bounds.size.width,self.self.view.bounds.size.height);
}
-(void)addDownload
{
    download=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStyleDone target:self action:@selector(DownLoad)];
    download.enabled=NO;
}


-(void)ChangeLayout
{
    _ImageView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _ImageView.center=self.view.center;
}
-(void)LoadImage
{
    isLiked=[Preference isPostLiked:param];
    [self initUI];
    MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在加载 0%";
    _ImageView.contentMode=UIViewContentModeScaleAspectFit;
    [_ImageView sd_setImageWithURL:[param valueForKey:@"sample_url"] placeholderImage:_placeholder options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在加载 %.1f%@",task*100,@"%"];
        
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
    share=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(Share)];
    
    self.navigationItem.rightBarButtonItems=@[like,download,share];
}

-(void)DownLoad
{
     UIImageWriteToSavedPhotosAlbum(_ImageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self ShowMessage:@"保存成功" InSeconds:2];
    }else
    {
        [self ShowMessage:@"保存失败" InSeconds:2];
    }
    
    
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
    NSLog(@"下一张");
    if(currentIndex==_Source.count-1)
    {
        [self ShowMessage:@"这是最后一张了哟 ╮(╯▽╰)╭ " InSeconds:2];
        return;
    }
    currentIndex++;
    MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在加载 0%";
    param=[_Source objectAtIndex:currentIndex];
    [_ImageView sd_setImageWithURL:[param valueForKey:@"sample_url"] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在加载 %.1f%@",task*100,@"%"];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        download.enabled=YES;
    }];
}
-(void)handleswpieright:(UISwipeGestureRecognizer *)recognizer;
{
    NSLog(@"上一张");
    if(currentIndex==0)
    {
        [self ShowMessage:@"这是第一张哦 ╮(╯▽╰)╭ " InSeconds:2];
        return;
    }
    currentIndex--;
    MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在加载 0%";
    param=[_Source objectAtIndex:currentIndex];
    [_ImageView sd_setImageWithURL:[param valueForKey:@"sample_url"] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在加载 %.1f%@",task*100,@"%"];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        download.enabled=YES;
    }];
}
-(void)Share
{
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:_ImageView.image forKey:@"image"];
    [dic setObject:[param valueForKey:@"sample_url"] forKey:@"url"];//支持微信分享
    [dic setObject:@"来自萌妹的萌图" forKey:@"title"];
    __weak __typeof(&*self)weakSelf = self;
    [weakSelf ShowActivityFrom:share with:dic];
    
}
-(void)Pinched:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state ==UIGestureRecognizerStateBegan) {
        
        currentTransform =_ImageView.transform;
        
    }
    
    if (gesture.state ==UIGestureRecognizerStateChanged) {
        
        CGAffineTransform tr =CGAffineTransformScale(currentTransform, gesture.scale, gesture.scale);
        
        _ImageView.transform = tr;
        
        _ImageView.frame =CGRectMake(0,0, _ImageView.frame.size.width,_ImageView.frame.size.height);
        
        _ImageView.center=self.view.center;
    }
    
    if ((gesture.state ==UIGestureRecognizerStateEnded) || (gesture.state ==UIGestureRecognizerStateCancelled)) {
        _lastPhotoScale =_lastPhotoScale*gesture.scale;
        
    }
    
}

-(void)viewWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.hidesBarsOnTap=NO;
}
-(void)didReceiveMemoryWarning
{
}
@end
