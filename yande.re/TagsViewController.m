//
//  TagsViewController.m
//  yande.re
//
//  Created by YuJie on 16/4/28.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "TagsViewController.h"
#import "TagsManager.h"
#import "tagsDelegate.h"

#import "TableDelegate.h"
#import <MBProgressHUD.h>
@interface TagsViewController ()<UISearchBarDelegate>
{
    NSMutableArray *tags;
    TagsDelegate *tagsDelegate;
    TagsManager *manager;
    UIView *shadowView;
    UITableView *searchResult;
    TableDelegate *tabledel;
    UITapGestureRecognizer *tap;
}
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@end

@implementation TagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField*searchField = [_SearchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    
    manager=[[TagsManager alloc] init];
    [manager installTagsDataBase];
    [self initShadowView];
    
    tags=[[NSMutableArray alloc] init];
    [self GetTags];
    tagsDelegate=[[TagsDelegate alloc] initWithTags:tags];
    __weak __typeof(&*self)weakSelf = self;
    [tagsDelegate setTagDidTapedBlock:^(NSIndexPath *indexPath, NSDictionary *tag) {
        weakSelf.SearchBar.text=[tag valueForKey:@"name"];
        [weakSelf StartSearch];
    }];
    _collection.delegate=tagsDelegate;
    _collection.dataSource=tagsDelegate;
    [_collection reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
}

/**
 *  初始化遮罩层
 */
-(void)initShadowView
{
    shadowView=[[UIView alloc] initWithFrame:self.view.bounds];
    shadowView.backgroundColor=[UIColor clearColor];
    UIVisualEffectView *effect=[[UIVisualEffectView alloc] initWithFrame:shadowView.bounds];
    effect.effect=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [shadowView addSubview:effect];

    tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(HideShadowView)];
    [effect addGestureRecognizer:tap];
}

/**
 *  读取数据库中的tag
 */
-(void)GetTags
{
    NSArray *popularTags=[manager SelectTop:20];
    //NSArray *newTags=[manager SelectNewset:5];
    [tags addObjectsFromArray:popularTags];
    //[tags addObjectsFromArray:newTags];
}

/**
 *  隐藏遮罩层
 */
-(void)HideShadowView
{
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha=0;
    } completion:^(BOOL finished) {
       [shadowView removeFromSuperview];
        shadowView.alpha=1;
        _SearchBar.showsCancelButton=NO;
        [_SearchBar endEditing:YES];
    }];
    
}

/**
 *  显示遮罩层
 */
-(void)ShowShadowView
{
    shadowView.alpha=0;
    [self.view insertSubview:shadowView belowSubview:_SearchBar];
    [UIView animateWithDuration:0.3 animations:^{
       shadowView.alpha=1;
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
    if(_SearchBar.text.length>0)
    {
        [self StartSearch];
    }
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self ShowTips];
    [searchResult reloadData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _SearchBar.showsCancelButton=NO;
    [_SearchBar endEditing:YES];
    [self HideShadowView];
}

/**
 *  开始搜索
 */
-(void)StartSearch
{
    NSString *tag=_SearchBar.text;
    UIViewController *dest=[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
    [dest setValue:@"SEARCHMODE" forKey:@"Mode"];
    [dest setValue:tag forKey:@"keyTag"];
    [self.navigationController pushViewController:dest animated:YES];
}

/**
 *  显示数据库内联想数据
 */
-(void)ShowTips
{
    NSArray *tagsSource=[manager QuerynameLike:_SearchBar.text];
    CGFloat height=0;
    if(tagsSource.count>=5)
    {
        height=175;
    }
    else
    {
        height=35*tagsSource.count;
    }
    
    if(searchResult==nil)
    {
         searchResult=[[UITableView alloc] initWithFrame:CGRectMake(0, self.SearchBar.frame.origin.y+_SearchBar.bounds.size.height, shadowView.bounds.size.width, height)];
        tabledel=[[TableDelegate alloc] init];
        [tabledel setValue:tagsSource forKey:@"Source"];
        __weak __typeof(&*self)weakSelf = self;
        [tabledel SettagBlock:^(NSIndexPath *indexPath, NSDictionary *tag) {
            [weakSelf.SearchBar endEditing:YES];
            [weakSelf HideShadowView];
            weakSelf.SearchBar.text=[tag valueForKey:@"name"];
            [weakSelf StartSearch];
        }];
        searchResult.separatorStyle=UITableViewCellSeparatorStyleNone;
        searchResult.backgroundColor=[UIColor clearColor];
        searchResult.dataSource=tabledel;
        searchResult.delegate=tabledel;
        [shadowView addSubview:searchResult];
        [searchResult reloadData];
    }
    else
    {
        [tabledel setValue:tagsSource forKey:@"Source"];
        [UIView animateWithDuration:0.1 animations:^{
            searchResult.frame=CGRectMake(0, self.SearchBar.frame.origin.y+self.SearchBar.bounds.size.height, shadowView.bounds.size.width, height);
        }];
       
        
    }
    
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
