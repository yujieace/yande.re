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
#import "miniTagsController.h"
#import <Masonry.h>
#import "ViewController.h"
@interface ADImageViewController ()<MWPhotoBrowserDelegate,miniTagsDelegate>
{
    BOOL isLiked;
    PreferenceModule *Preference;
    NSUInteger currentIndex;
}
@property (nonatomic,strong) miniTagsController *tagsController;
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
    [self initTagsController];
}

-(void)initTagsController{
    _tagsController = [[miniTagsController alloc] init];
    NSArray *source=[[_imageList[currentIndex] valueForKey:@"tags"] componentsSeparatedByString:@" "];
    _tagsController.source = source;
    [_tagsController.tags reloadData];
    _tagsController.hidden=YES;
    _tagsController.delegate=self;
    [self.view addSubview:_tagsController];
    [_tagsController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self.view);
        make.height.equalTo(@175);
    }];
    
    
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
    [FTPopOverMenu showFromEvent:event withMenuArray:
  @[@"下载",isLiked?@"取消收藏":@"收藏",_tagsController.hidden?@"显示标签":@"隐藏标签"] imageArray:@[@"download",isLiked?@"like":@"unlike",@"tag"] doneBlock:^(NSInteger selectedIndex) {
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
                
            }break;
            case 2:{
                [self showOrHideTags];
            }break;
                
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

-(void)showOrHideTags{
    _tagsController.hidden = !_tagsController.hidden;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index{
    currentIndex=index;
    NSDictionary *temp = _imageList[index];
    isLiked = [Preference isPostLiked:temp];
    NSArray *source=[[temp valueForKey:@"tags"] componentsSeparatedByString:@" "];
    _tagsController.source = source;
    [_tagsController.tags reloadData];
}

-(void)tagsSelected:(NSString *)tags{
    UIViewController *dest=[[UIApplication sharedApplication].keyWindow.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [dest setValue:@"SEARCHMODE" forKey:@"Mode"];
    [dest setValue:tags forKey:@"keyTag"];
    [self.navigationController pushViewController:dest animated:YES];
}

@end
