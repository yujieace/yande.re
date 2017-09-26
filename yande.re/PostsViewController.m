//
//  PostsViewController.m
//  yande.re
//
//  Created by YuJie on 16/4/13.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "PostsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RatingFilter.h"
@implementation PostsViewController
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define SCREEN_SIZE self.view.bounds.size
-(void)viewDidLoad
{
    self.title=[_pool valueForKey:@"name"];
    _Source=[[NSMutableArray alloc] init];
    for (NSDictionary *temp in [_pool valueForKey:@"posts"]) {
        if([RatingFilter Filter:temp])
        {
            [_Source addObject:temp];
        }
    }
    Preference=[[PreferenceModule alloc] init];
    isLiked=[Preference isPoolLiked:_pool];
    [self initUI];
    del=[[CommenPostdelegate alloc] init];
    [del setSource:_Source];
    [del SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        NSDictionary *dic=post;
        UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailView"];
        [dest setValue:dic forKey:@"param"];
        [dest setValue:[NSString stringWithFormat:@"%ld",index.row] forKey:@"index"];
        UIImageView *image=[[UIImageView alloc] init];
        [image sd_setImageWithURL:[dic valueForKey:@"preview_url"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [dest setValue:image.image forKey:@"placeholder"];
        [dest setValue:_Source forKey:@"Source"];
        dest.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dest animated:YES];
    }];
    _collectionView.dataSource=del;
    _collectionView.delegate=del;
    [_collectionView reloadData];
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
    self.navigationItem.rightBarButtonItem=like;
}


-(void)AddFavourite
{
    if(isLiked)
        [Preference RemovePoolLiked:_pool];
    else
        [Preference AddPoolLiked:_pool];
    isLiked=[Preference isPoolLiked:_pool];
    [self initUI];
}
@end
