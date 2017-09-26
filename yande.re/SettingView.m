//
//  SettingView.m
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "SettingView.h"
#import "RatingFilter.h"
#import <SDWebImageManager.h>
#import "TagsManager.h"
#import <MBProgressHUD.h>
#import "CloudSyncManager.h"
@implementation SettingView

-(void)viewDidLoad
{
    _Age_protect_switch=[[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];    _Age_protect_switch.on=[RatingFilter isProtectOn];
    [_Age_protect_switch addTarget:self action:@selector(AgeProtect:) forControlEvents:UIControlEventValueChanged];
    _CleanCacheButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_CleanCacheButton setTitle:@"立即清理" forState:UIControlStateNormal];
    [_CleanCacheButton addTarget:self action:@selector(CleanCache:) forControlEvents:UIControlEventTouchUpInside];
    [_CleanCacheButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _CleanCacheButton.titleLabel.textAlignment=NSTextAlignmentRight;
    _CleanCacheButton.titleLabel.font=[UIFont systemFontOfSize:12];


    _updateTags=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_updateTags setTitle:@"立即更新" forState:UIControlStateNormal];
    [_updateTags addTarget:self action:@selector(updateLocalTagDB) forControlEvents:UIControlEventTouchUpInside];
    [_updateTags setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _updateTags.titleLabel.textAlignment=NSTextAlignmentRight;
    _updateTags.titleLabel.font=[UIFont systemFontOfSize:12];

}

-(void)viewDidAppear:(BOOL)animated
{
    [_SettingView reloadData];
}

- (IBAction)AgeProtect:(id)sender {
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ratesetting=[[NSMutableDictionary alloc] init];
    UISwitch *switcher=sender;
    if(switcher.on)
    {
        [ratesetting setValue:@"4" forKey:@"age"];
    }
    else
    {
        [ratesetting setValue:@"18" forKey:@"age"];
        
    }
    [user setObject:ratesetting forKey:@"rating"];
    [user synchronize];
}
- (IBAction)CleanCache:(id)sender {
    [[SDWebImageManager sharedManager].imageCache clearDisk];
    CGFloat size=(CGFloat)([[SDWebImageManager sharedManager].imageCache getSize])/1024/1024;
    _CacheLabel.text=[NSString stringWithFormat:@"图片缓存 %.2f MB",size];
}
-(void)updateLocalTagDB
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HideHUD) name:@"UPDATEFINISHED" object:nil];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TagsManager *manager=[[TagsManager alloc] init];
    [manager UpdatePopularTag];
}
-(void)HideHUD
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UPDATEFINISHED" object:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma Tabledelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text=@"年龄保护";
            cell.detailTextLabel.text=@"自动过滤不安全评级的内容";
            cell.accessoryView=_Age_protect_switch;
        }
            break;
        case 1:
        {
            CGFloat size=(CGFloat)([[SDWebImageManager sharedManager].imageCache getSize])/1024/1024;
            cell.textLabel.text=[NSString stringWithFormat:@"图片缓存 %.2f MB",size];
            cell.detailTextLabel.text=@"当前图片缓存所占空间";
            cell.accessoryView=_CleanCacheButton;
        }
            break;
        case 2:
        {
            cell.textLabel.text=@"更新Tag";
            cell.detailTextLabel.text=@"更新本地Tag数据库，可能耗费数十秒";
            cell.accessoryView=_updateTags;
        }
            break;
        case 3:
        {
            cell.textLabel.text=@"云端同步收藏夹";
            cell.detailTextLabel.text=@"将整合上传本地数据库，耗时不定";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 4:
        {
            cell.textLabel.text=@"";
            cell.detailTextLabel.text=@"";
        }
            break;
            
        default:
        {}
            break;
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==3)
    {
        //同步云端
        CloudSyncManager *manager=[[CloudSyncManager alloc] init];
        NSLog(@"开始上传");
        [manager syncWithCloud];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
@end
