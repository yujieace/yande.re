//
//  DownloadTask.h
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 Yujie All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadTask;

@protocol DownloadTaskDelegate<NSObject>
-(void)downloadTaskFinished:(DownloadTask *)task state:(BOOL) state;
-(void)downloadProcess:(DownloadTask*)task current:(NSUInteger)current totol:(NSUInteger)total;
@end

@interface DownloadTask : NSObject<NSCoding>
@property (nonatomic,weak) id<DownloadTaskDelegate> delegate;
@property (nonatomic,strong) NSURL *url;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,strong) NSDate *createDate;
@property (nonatomic,assign) NSInteger taskState;
@property (nonatomic,assign) double downloadProcess;
@end
