//
//  PhoteViewController.m
//  yande.re
//
//  Created by YuJie on 16/5/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "PhotoViewController.h"
#import "ViewController+Message.h"
#import "ViewController+Share.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "PreferenceModule.h"
#import "miniTagsController.h"
#import <Masonry.h>

@interface PhotoViewController ()<miniTagsDelegate>

{
    miniTagsController *tags;
}
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Preference=[[PreferenceModule alloc] init];
    [self addDownload];
    [self initBarBtn];
    _collection.dataSource=self;
    _collection.delegate=self;
    [_collection reloadData];
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLayout) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    NSArray *source=[[_param valueForKey:@"tags"] componentsSeparatedByString:@" "];
    tags=[[miniTagsController alloc] init];
    tags.source=[source copy];
    tags.delegate=self;
    [self.view addSubview:tags];
    [tags mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.equalTo(self.view).multipliedBy(0.15);
    }];
    self.navigationController.hidesBarsOnTap=NO;
    self.navigationController.hidesBarsOnSwipe=NO;
    self.navigationController.hidesBarsWhenVerticallyCompact=NO;
}

-(void)tagsControllerShow
{
    tags.hidden=!tags.hidden;
}

-(void)tagsSelected:(NSString *)tag
{
    UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [dest setValue:@"SEARCHMODE" forKey:@"Mode"];
    [dest setValue:tag forKey:@"keyTag"];
    [self.navigationController pushViewController:dest animated:YES];
    
}
-(void)ChangeLayout
{
    [_collection reloadData];
    _collection.contentOffset=CGPointMake(currentIndex*self.view.bounds.size.width, _collection.contentOffset.y);
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.hidesBarsOnTap=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [_collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[_index integerValue] inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
}
-(void)addDownload
{
    download=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download"] style:UIBarButtonItemStyleDone target:self action:@selector(DownLoad)];
    download.enabled=NO;
     share=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStyleDone target:self action:@selector(Share)];
    share.enabled=NO;
}


-(void)initBarBtn
{
    NSString *name=[[NSString alloc] init];
    isLiked=[Preference isPostLiked:_param];
    if(isLiked)
        name=@"like";
    else
        name=@"unlike";
    like=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:name] style:UIBarButtonItemStyleDone target:self action:@selector(AddFavourite)];
    if(isLiked)
        like.tintColor=[UIColor redColor];
   
    self.navigationItem.rightBarButtonItems=@[like,download,share];
}

-(void)DownLoad
{
    MBProgressHUD *progress=[MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在下载 0.0%";

    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.param[@"jpeg_url"]] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在下载 %.1f%@",task*100,@"%"];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       if(finished&&!error)
       {
           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
       }
        else
        {
            [self ShowMessage:@"下载失败" InSeconds:1];
        }
    }];
   
}

-(void)Share
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:currentImage forKey:@"image"];
    __weak __typeof(&*self)weakSelf = self;
    [weakSelf ShowActivityFrom:share with:dic];
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [self ShowMessage:@"保存成功" InSeconds:1];
    }else
    {
        [self ShowMessage:@"保存失败" InSeconds:1];
    }
    
    
}

-(void)updateCurrentImage
{
    UIImageView *imageview=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageview sd_setImageWithURL:[self.param valueForKey:@"sample_url"]];
    currentImage=imageview.image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)AddFavourite
{
    if(isLiked)
        [Preference RemovePostLiked:_param];
    else
        [Preference AddPostLiked:_param];
    isLiked=[Preference isPostLiked:_param];
    [self initBarBtn];
}

#pragma Collection Protocol

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _Source.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tagsControllerShow];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param=[_Source objectAtIndex:indexPath.row];
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"PIC" forIndexPath:indexPath];
    
    if(cell==nil)
    {
        cell=[[UICollectionViewCell alloc] init];
    }
    UIImageView *imageview=[cell viewWithTag:2];
    if(imageview==nil)
    {
        imageview=[[UIImageView alloc] initWithFrame:cell.bounds];
        imageview.tag=2;
        imageview.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
        imageview.contentMode=UIViewContentModeScaleAspectFit;
    }
    imageview.frame=cell.bounds;
    MBProgressHUD *progress=[imageview viewWithTag:3];
    if(progress==nil)
    {
        progress=[MBProgressHUD showHUDAddedTo:imageview animated:YES];
        progress.tag=3;
    }
    
    progress.mode=MBProgressHUDModeAnnularDeterminate;
    progress.labelText=@"正在加载 0%";
    UIImage *placeholder=[UIImage imageNamed:@"placeholder"];
    if(indexPath.row==[_index integerValue])
    {
        placeholder=_placeholder;
    }
    [imageview sd_setImageWithURL:[param valueForKey:@"sample_url"] placeholderImage:placeholder options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        float task=(float)receivedSize/(float)expectedSize;
        if(task==-0.0)
            task=0;
        progress.progress=task;
        progress.labelText=[NSString stringWithFormat:@"正在加载 %.1f%@",task*100,@"%"];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:imageview animated:YES];
        [self updateCurrentImage];
        download.enabled=YES;
        share.enabled=YES;
    }];
    cell.backgroundColor=[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1];
    [cell addSubview:imageview];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index=scrollView.contentOffset.x/self.view.bounds.size.width;
    if(index!=currentIndex)
    {
        currentIndex=index;
        _param=[_Source objectAtIndex:index];
        NSArray *source=[[_param valueForKey:@"tags"] componentsSeparatedByString:@" "];
        source=[source sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *o1=obj1;
            NSString *o2=obj2;
            if (o1.length>o2.length) {
                return NSOrderedAscending;
            }
            else
                return NSOrderedDescending;
        }];
        tags.source=[source copy];
        [tags.tags reloadData];
        
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        BOOL Exsited=[manager diskImageExistsForURL:[NSURL URLWithString:[_param valueForKey:@"sample_url"]]];
        if(!Exsited)
        {
            download.enabled=NO;
            share.enabled=NO;
        }
        else
        {
            download.enabled=YES;
            share.enabled=YES;
            [self updateCurrentImage];
            
        }
        [self initBarBtn];
        
    }
}

@end
