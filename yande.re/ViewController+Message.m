//
//  ViewController+Message.m
//  yande.re
//
//  Created by hnzc on 16/5/10.
//  Copyright © 2016年 hnzc. All rights reserved.
//

#import "ViewController+Message.h"
#import <MBProgressHUD.h>


@implementation UIViewController (Message)

-(void)ShowMessage:(NSString *)msg InSeconds:(unsigned int)seconds
{
    MBProgressHUD *hud=[[MBProgressHUD alloc ]initWithView:self.view];
    hud.mode=MBProgressHUDModeText;
    [self.view addSubview:hud];
    hud.labelText=msg;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(seconds);
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
}


@end
