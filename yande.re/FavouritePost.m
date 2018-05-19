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
#import "ADImageViewController.h"
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
        ADImageViewController *browser =[[ADImageViewController alloc] init];
        browser.imageList=[Source copy];
        [browser setCurrentPhotoIndex:index.row];
        [self.navigationController pushViewController:browser animated:YES];
    }];
}
@end
