//
//  ViewController+Message.m
//  yande.re
//
//  Created by YuJie on 16/5/10.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "ViewController+Message.h"
#import <RKDropdownAlert.h>


@implementation UIViewController (Message)

-(void)ShowMessage:(NSString *)msg InSeconds:(unsigned int)seconds
{
    [RKDropdownAlert title:msg time:seconds];
}


@end
