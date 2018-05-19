//
//  DownloadManager.h
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 Yujie All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
@interface DownloadManager : NSObject
+(DownloadManager*)sharedInstance;
/**
 添加任务

 @param task 任务
 */
-(void)addTask:(DownloadTask *)task;


/**
 移除任务（相同URL）

 @param task 任务
 */
-(void)removeTask:(DownloadTask *)task;
@end
