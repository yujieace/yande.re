//
//  TagsViewController.m
//  yande.re
//
//  Created by YuJie on 16/4/28.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "TagsViewController.h"
#import "TagsManager.h"
#import "TagsDelegate.h"
@interface TagsViewController ()<UISearchBarDelegate>
{
    NSMutableArray *tags;
    TagsDelegate *tagsDelegate;
    TagsManager *manager;
    UIView *shadowView;
}
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager=[[TagsManager alloc] init];
    [self initShadowView];
    
    tags=[[NSMutableArray alloc] init];
    [self GetTags];
    tagsDelegate=[[TagsDelegate alloc] initWithTags:tags];
    __weak __typeof(&*self)weakSelf = self;
    [tagsDelegate setTagDidTapedBlock:^(NSIndexPath *indexPath, NSDictionary *tag) {
        weakSelf.SearchBar.text=[tag valueForKey:@"name"];
    }];
    _collection.delegate=tagsDelegate;
    _collection.dataSource=tagsDelegate;
    [_collection reloadData];
    
    //获取热门的10个tag 最新的10个tag
    //初始化tag列表，搜索关键字查询
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // something
        [manager installTagsDataBase];
        [manager UpdateNewset];
        [manager UpdatePopularTag];
    });
    // Do any additional setup after loading the view.
}
-(void)initShadowView
{
    shadowView=[[UIView alloc] initWithFrame:CGRectMake(0, _SearchBar.bounds.size.height+25, self.view.bounds.size.width, self.view.bounds.size.height-(_SearchBar.bounds.size.height+25))];
    shadowView.backgroundColor=[UIColor blackColor];
    shadowView.alpha=0.6;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideShadowView)];
    [shadowView addGestureRecognizer:tap];
}
-(void)GetTags
{
    NSArray *popularTags=[manager SelectTop:5];
    NSArray *newTags=[manager SelectNewset:5];
    [tags addObjectsFromArray:popularTags];
    [tags addObjectsFromArray:newTags];
}

-(void)HideShadowView
{
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha=0;
    } completion:^(BOOL finished) {
       [shadowView removeFromSuperview];
        shadowView.alpha=0.6;
        _SearchBar.showsCancelButton=NO;
        [_SearchBar endEditing:YES];
    }];
    
}
-(void)ShowShadowView
{
    shadowView.alpha=0;
    [self.view addSubview:shadowView];
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha=0.6;
    } completion:^(BOOL finished) {
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma SearchProtocol
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    _SearchBar.showsCancelButton=YES;
    [self ShowShadowView];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"SearchBarClicked");
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancled");
    _SearchBar.showsCancelButton=NO;
    [_SearchBar endEditing:YES];
    [self HideShadowView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
