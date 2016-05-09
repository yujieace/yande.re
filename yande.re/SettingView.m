//
//  SettingView.m
//  yande.re
//
//  Created by 於杰 on 16/4/12.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "SettingView.h"
#import "RatingFilter.h"
#import <SDWebImageManager.h>

@implementation SettingView

-(void)viewDidLoad
{
    _Age_protect_switch.on=[RatingFilter isProtectOn];

}

-(void)viewDidAppear:(BOOL)animated
{
    CGFloat size=(CGFloat)([[SDWebImageManager sharedManager].imageCache getSize])/1024/1024;
    _CacheLabel.text=[NSString stringWithFormat:@"图片缓存 %.2f MB",size];
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

@end
