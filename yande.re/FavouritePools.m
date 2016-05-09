//
//  FavouritePools.m
//  yande.re
//
//  Created by 於杰 on 16/4/27.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "FavouritePools.h"
#import "MJRefresh.h"
@implementation FavouritePools
-(void)viewDidLoad
{
    prefrence=[[PreferenceModule alloc] init];
    pool=[[CommenPoolDelegate alloc] init];
    _PoolsCollection.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(Loaddata)];
    [self DidSelect];
    [self ModifyCell];
    _PoolsCollection.delegate=pool;
    _PoolsCollection.dataSource=pool;
    [_PoolsCollection.header beginRefreshing];

}
-(void)ModifyCell
{
    __block int temp=1;
    [pool setCellModifyBlock:^(UICollectionViewCell *cell, NSIndexPath *index, NSDictionary *post) {
        cell.layer.cornerRadius=10;
        temp=2;
    }];
}
-(void)DidSelect
{
    [pool SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        NSDictionary *dic=post;
        UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"PostsView"];
        [dest setValue:dic forKey:@"pool"];
        dest.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dest animated:YES];
    }];
}
-(void)Loaddata
{
    NSArray *array=[prefrence GetFravouritePoolList];
    NSMutableArray *source=[[NSMutableArray alloc] init];
    for (NSDictionary *temp in array) {
        [source addObject:[temp valueForKey:@"info"]];
    }
    [pool setSource:source];
    [_PoolsCollection reloadData];
    [_PoolsCollection.header endRefreshing];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [_PoolsCollection reloadData];
}
@end
