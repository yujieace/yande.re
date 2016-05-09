//
//  PoolsViewController.m
//  yande.re
//
//  Created by 於杰 on 16/4/12.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "PoolsViewController.h"
#import "UIView+Shadow.h"
#import "PoolsSource.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RatingFilter.h"
#include "NSnull+Json.h"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define POOLSCACHE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/Pools.plist"]
#define SCREEN_SIZE self.view.bounds.size
@implementation PoolsViewController
-(void)viewDidLoad
{
    [self LoadByCache];
    _PoolsCollectView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(LoadData)];
    _PoolsCollectView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMore)];
    del=[[CommenPoolDelegate alloc] init];
    [del setSource:_souce];
    [del SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        NSDictionary *dic=post;
        UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"PostsView"];
        [dest setValue:dic forKey:@"pool"];
        dest.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:dest animated:YES];
    }];
    _PoolsCollectView.dataSource=del;
    _PoolsCollectView.delegate=del;
    [_PoolsCollectView reloadData];
    [_PoolsCollectView.header beginRefreshing];
}
-(void)didReceiveMemoryWarning
{
}

-(void)LoadByCache
{
    NSData *data=[NSData dataWithContentsOfFile:POOLSCACHE];
    if(data==nil)
    {
        _souce=[[NSMutableArray alloc] init];
    }
    else
    {
        NSArray *array=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        _souce=[[NSMutableArray alloc] initWithArray:array];
        if(_souce==nil)
            _souce=[[NSMutableArray alloc] init];
            
    }

    
    
}

-(void)LoadData
{
    _page=1;
    [self refresh];
}
-(void)LoadMore
{
    _page++;
    [self refresh];
}
-(void)refresh
{
    NSDictionary *param=[[NSDictionary alloc] initWithObjectsAndKeys:@"450",@"limit",[NSString stringWithFormat:@"%ld",_page],@"page",nil];
    PoolsSource *datasouce=[[PoolsSource alloc] init];
    [datasouce StartGetPools:param withBlock:^(NSMutableArray *Result) {
        NSData *json=[NSJSONSerialization dataWithJSONObject:Result options:NSJSONWritingPrettyPrinted error:nil];
        [json writeToFile:POOLSCACHE atomically:YES];
        if(_page==1)
        {
            [_souce removeAllObjects];
        }
        for (NSDictionary *temp in Result) {
            NSArray *posts=[temp valueForKey:@"posts"];
            for (NSDictionary *post in posts) {
                if ([RatingFilter Filter:post]) {
                    [_souce addObject:temp];
                    break;
                }
            }
            
        }
        [del setSource:_souce];
        [_PoolsCollectView reloadData];
        [_PoolsCollectView.header endRefreshing];
        [_PoolsCollectView.footer endRefreshing];
    }];

}


@end
