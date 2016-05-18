//
//  ViewController.m
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DataSouce.h"
#import "MJRefresh.h"
#import "Singleton.h"
#import "RatingFilter.h"
#import "CommenPostdelegate.h"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define POSTCACHE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/POST.plist"]
#define SCREEN_SIZE [self.view.bounds.size]
@interface ViewController ()<DataSouceDelegate>
@property (nonatomic,strong) NSMutableArray *Source;
@property (weak, nonatomic) IBOutlet UICollectionView *collectView;
@property NSInteger page;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    
    self.view.layer.contents=(__bridge id _Nullable)([UIImage imageNamed:@"logo"].CGImage);
    _Source=[[NSMutableArray alloc] init];
    _collectView.header.backgroundColor=[UIColor clearColor];
    _collectView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_collectView.header setAutomaticallyChangeAlpha:YES];
    _collectView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMore)];
    del=[[CommenPostdelegate alloc] init];
    
    [del SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        NSDictionary *dic=post;
        UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"ShowDetailView"];
        [dest setValue:dic forKey:@"param"];
        [dest setValue:[NSString stringWithFormat:@"%ld",index.row] forKey:@"index"];
        UIImageView *image=[[UIImageView alloc] init];
        image.contentMode=UIViewContentModeScaleAspectFit;
        [image sd_setImageWithURL:[dic valueForKey:@"preview_url"] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [dest setValue:image.image forKey:@"placeholder"];
        [dest setValue:_Source forKey:@"Source"];
        dest.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController pushViewController:dest animated:YES];

    }];
    _collectView.dataSource=del;
    _collectView.delegate=del;
    NSMutableDictionary *shared=[Singleton GetSharedData];
    [_Source addObjectsFromArray:[shared valueForKey:@"Source"]];
    [del setSource:_Source];
    [_collectView reloadData];
    [_collectView.header beginRefreshing];
        // Do any additional setup after loading the view, typically from a nib.
}
-(void)loadData
{
    _page=1;
    
    [self Refresh];
}
-(void)Refresh
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [dic setObject:@"1000" forKey:@"limit"];
    [dic setObject:[NSString stringWithFormat:@"%ld",(long)_page] forKey:@"page"];
    DataSouce *data=[[DataSouce alloc] init];
    data.delegate=self;
    [data GetPostListForCycle:Default Param:dic];
}

-(void)LoadMore
{
    _page++;
    [self Refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)DataCallback:(NSArray *)array
{
    NSMutableArray *marray=[[NSMutableArray alloc] init];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=[array objectAtIndex:i];
        if([RatingFilter Filter:dic])
        {
            [marray addObject:dic];
        }
    }
    if(_page==1)
    {
        [_Source removeAllObjects];
    }
    [_Source addObjectsFromArray:marray];
    [del setSource:_Source];
    NSMutableDictionary *shared=[Singleton GetSharedData];
    [shared setObject:_Source forKey:@"Source"];
    [_collectView reloadData];
    [_collectView.header endRefreshing];
    [_collectView.footer endRefreshing];
    
    NSData *data=[NSJSONSerialization dataWithJSONObject:_Source options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:POSTCACHE atomically:YES];
}

@end
