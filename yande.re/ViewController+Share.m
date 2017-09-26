//
//  ViewController+Share.m
//  yande.re
//
//  Created by YuJie on 16/5/10.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "ViewController+Share.h"
#import <Social/Social.h>
#import "ViewController+Message.h"
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
@implementation UIViewController(share)


-(void)ShowActivityFrom:(UIBarButtonItem *)barItem with:(NSDictionary *)param
{
    UIImage *image=[param valueForKey:@"image"];
    NSArray *array=@[image];
    
    UIActivityViewController *activity=[[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    if (isPad) {
        UIPopoverController *pop=[[UIPopoverController alloc] initWithContentViewController:activity];
        [pop setPopoverContentSize:CGSizeMake(self.view.bounds.size.width/3,self.view.bounds.size.width/3) animated:YES];
        [pop presentPopoverFromBarButtonItem:barItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else
    {
        [self presentViewController:activity animated:YES completion:nil];
    }
    activity.completionWithItemsHandler=^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
        if(completed)
        {
            [self ShowMessage:@"分享成功" InSeconds:2];
        }
        else
        {
            [self ShowMessage:@"分享失败" InSeconds:2];
        }
    };
}
@end
