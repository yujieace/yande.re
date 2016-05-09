//
//  SettingView.h
//  yande.re
//
//  Created by 於杰 on 16/4/12.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *Age_protect_switch;
@property (weak, nonatomic) IBOutlet UIButton *CleanCacheButton;
@property (weak, nonatomic) IBOutlet UILabel *CacheLabel;

@end
