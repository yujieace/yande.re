//
//  CloudSyncManager.m
//  yande.re
//
//  Created by SH-LX on 2017/4/19.
//  Copyright © 2017年 hnzc. All rights reserved.
//

#import "CloudSyncManager.h"
#import "PreferenceModule.h"
#import <BmobSDK/Bmob.h>
#import "NSDate+ToString.h"
#import <MBProgressHUD.h>
@implementation CloudSyncManager

-(instancetype)init
{
    self=[super init];
    skip=0;
    postNum=0;
    hud=[MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    return self;
}
-(void)syncWithCloud
{
    
    BmobQuery *query=[BmobQuery queryWithClassName:@"favourite"];
    if(skip>=postNum&&skip>0)
    {
        hud.labelText=@"同步完成";
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        return;
    }
    
    
    if(postNum==0)
    {
        hud.labelText=@"正在获取收藏夹总数";
        [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
           if(!error)
           {
               if (number>0) {
                   postNum=(NSInteger)number;
                   [self syncWithCloud];
               }
           }
            else
            {
                hud.labelText=@"获取收藏夹总数异常";
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
        }];
    }
    else
    {
        PreferenceModule *module=[[PreferenceModule alloc] init];
        
        [query setLimit:1000];
        [query setSkip:skip];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if(!error)
            {
                skip+=array.count;
                for (NSInteger i=0;i<array.count;i++) {
                    BmobObject *obj=array[i];
                    hud.labelText=[NSString stringWithFormat:@"正在写入本地数据库 %ld/%ld",skip+i,postNum];
                    NSString *json=[obj objectForKey:@"PostData"];
                    NSDictionary *post=[NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
                    if([[obj objectForKey:@"Deleted"] integerValue]==0)
                    {
                        [module writePostToDB:post];
                    }
                    else
                    {
                        [module removePost:post];
                    }
                    
                    
                }
                [self syncWithCloud];
            }
            else
            {
                NSLog(@"%@",error);
                hud.labelText=[NSString stringWithFormat:@"%@",error];
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            }
            
        }];
    }
    
    
}


@end
