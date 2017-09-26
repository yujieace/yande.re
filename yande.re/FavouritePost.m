//
//  FavouritePost.m
//  yande.re
//
//  Created by YuJie on 16/4/27.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "FavouritePost.h"
#import "MJRefresh.h"
#import "RatingFilter.h"
@implementation FavouritePost
-(void)viewDidLoad
{
    Source=[[NSMutableArray alloc] init];
    del=[[CommenPostdelegate alloc] init];
    [self DidSelect];
    pre=[[PreferenceModule alloc] init];
    _postCollection.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    _postCollection.dataSource=del;
    _postCollection.delegate=del;
    [_postCollection.header beginRefreshing];
}

-(void)LoadData
{
    NSArray *array=[pre GetFravouritePostList];
    [Source removeAllObjects];
    for (NSDictionary *temp in array) {
        if([RatingFilter Filter:[temp valueForKey:@"info"]])
        [Source addObject:[temp valueForKey:@"info"]];
    }
    [del setSource:Source];
    [_postCollection reloadData];
    [_postCollection.header endRefreshing];
}

-(void)DidSelect
{
    [del SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        NSDictionary *dic=post;
        UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailView"];
        [dest setValue:dic forKey:@"param"];
        [dest setValue:[NSString stringWithFormat:@"%ld",index.row] forKey:@"index"];
        UIImageView *image=[[UIImageView alloc] init];
        image.contentMode=UIViewContentModeScaleAspectFit;
        [image sd_setImageWithURL:[dic valueForKey:@"preview_url"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [dest setValue:image.image forKey:@"placeholder"];
        [dest setValue:Source forKey:@"Source"];
        dest.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:dest animated:YES];
    }];
}
@end
