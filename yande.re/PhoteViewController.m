//
//  PhoteViewController.m
//  yande.re
//
//  Created by hnzc on 16/5/11.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "PhoteViewController.h"
#import "ViewController+Message.h"
#import "ViewController+Share.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "PreferenceModule.h"
@interface PhoteViewController ()

@end

@implementation PhoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Preference=[[PreferenceModule alloc] init];
    [self addDownload];
    [self initBarBtn];
    _collection.dataSource=self;
    _collection.delegate=self;
    [_collection reloadData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeLayout) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
-(void)ChangeLayout
{
    [_collection reloadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    _collection.dataSource=nil;
    _collection.delegate=nil;
    self.navigationController.hidesBarsOnTap=NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.hidesBarsOnTap=YES;
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
    UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
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
        [self ShowMessage:@"保存成功" InSeconds:2];
    }else
    {
        [self ShowMessage:@"保存失败" InSeconds:2];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma Collection Protocol

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _Source.count;
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
        imageview=[[UIImageView alloc] init];
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
        [self updateCurrentImage];
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
            
        }
        
    }
}
/*
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
    
}*/
@end
