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
#import "ADImageViewController.h"
#import <Masonry.h>
#import <objc/runtime.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define POSTCACHE [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/POST.plist"]
#define SCREEN_SIZE [self.view.bounds.size]
@interface ViewController ()<DataSouceDelegate>
@property (nonatomic,strong) NSMutableArray *Source;
@property (strong, nonatomic) IBOutlet UICollectionView *collectView;

@property NSInteger page;
@end

@implementation ViewController
-(instancetype)init{
    self=[super init];
    
    return self;
}

-(UICollectionView *)collectView
{
    if(_collectView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.view addSubview:_collectView];
        [_collectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;

    if([_Mode isEqualToString:@"SEARCHMODE"])
    {
        self.title=[NSString stringWithFormat:@"%@的搜索结果",_keyTag];
    }
    _Source=[[NSMutableArray alloc] init];
    self.collectView.header.backgroundColor=[UIColor clearColor];
    _collectView.header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_collectView.header setAutomaticallyChangeAlpha:YES];
    _collectView.footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(LoadMore)];
    del=[[CommenPostdelegate alloc] init];
    
    [del SetDidSelectBlock:^(NSIndexPath *index, NSDictionary *post) {
        ADImageViewController *browser =[[ADImageViewController alloc] init];
        browser.imageList=[_Source copy];
        [browser setCurrentPhotoIndex:index.row];
        [self.navigationController pushViewController:browser animated:YES];
    }];
    _collectView.dataSource=del;
    _collectView.delegate=del;
    if(![_Mode isEqualToString:@"SEARCHMODE"])
    {
        NSMutableDictionary *shared=[Singleton GetSharedData];
        [_Source addObjectsFromArray:[shared valueForKey:@"Source"]];
    }
    [del setSource:_Source];
    [_collectView reloadData];
    [_collectView.header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor]};

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
    if([_Mode isEqualToString:@"SEARCHMODE"])
    {
        [dic setObject:_keyTag forKey:@"tags"];
    }
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
