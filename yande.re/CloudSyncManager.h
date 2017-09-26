//
//  CloudSyncManager.h
//  yande.re
//
//  Created by SH-LX on 2017/4/19.
//  Copyright © 2017年 hnzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
@interface CloudSyncManager : NSObject
{
    NSInteger skip;
    NSInteger postNum;
    MBProgressHUD *hud;
}
-(void)syncWithCloud;
@end
