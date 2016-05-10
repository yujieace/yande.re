//
//  SettingView.h
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *Age_protect_switch;
@property (weak, nonatomic) IBOutlet UIButton *CleanCacheButton;
@property (weak, nonatomic) IBOutlet UILabel *CacheLabel;

@end
