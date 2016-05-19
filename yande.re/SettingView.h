//
//  SettingView.h
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UISwitch *Age_protect_switch;
@property (strong, nonatomic) IBOutlet UIButton *CleanCacheButton;
@property (strong, nonatomic) IBOutlet UILabel *CacheLabel;
@property (weak, nonatomic) IBOutlet UITableView *SettingView;
@property (strong,nonatomic) IBOutlet UIButton *updateTags;
@end
