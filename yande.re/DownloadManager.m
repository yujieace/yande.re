//
//  DownloadManager.m
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 Yujie All rights reserved.
//

#import "DownloadManager.h"
@interface DownloadManager()<NSURLSessionDownloadDelegate>
{
    NSURLSession *session;
    NSURLSessionDownloadTask *globalTask;
}
@property (nonatomic,strong) NSMutableArray *taskList;
@property (nonatomic,strong) NSMutableArray *downLoadingList;
@end
@implementation DownloadManager
+(DownloadManager *)sharedInstance{
    static DownloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownloadManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    self=[super init];
    _taskList = [[NSMutableArray alloc] init];
    _downLoadingList = [[NSMutableArray alloc] init];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}


-(void)addTask:(DownloadTask *)task
{
    [_taskList addObject:task];
    [self trigerDownloadList];
}

-(void)trigerDownloadList{
    if(_downLoadingList.count==0 && _taskList.count>0){
        [_downLoadingList addObject:[_taskList firstObject]];
        [self startDownLoad];
    }
}

-(void)startDownLoad{
    if(_downLoadingList.count==0){
        return;
    }
    DownloadTask *taskInfo = [_downLoadingList firstObject];
    taskInfo.taskState =1;
    globalTask = [session downloadTaskWithURL:taskInfo.url];
    [globalTask resume];
}

-(void)removeTask:(DownloadTask *)task{
    for(DownloadTask *temp in _taskList){
        if([temp.url isEqual:task.url]){
            [_taskList removeObject:temp];
            [_downLoadingList removeObject:_taskList];
        }
    }
}



#pragma mark URLSession代理

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"下载完成 %@",location);
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    NSFileManager *mgr = [NSFileManager defaultManager];
    [mgr moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    
    DownloadTask *task = [_downLoadingList firstObject];
    task.filePath = file;
    if(task.delegate){
        [task.delegate downloadTaskFinished:task state:YES];
    }
    [_downLoadingList removeObject:task];
    [_taskList removeObject:task];
    [self trigerDownloadList];
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //NSLog(@"%lld|%lld|%lld",bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
    DownloadTask *task = [_downLoadingList firstObject];
    if(task.delegate){
        [task.delegate downloadProcess:task current:totalBytesWritten totol:totalBytesExpectedToWrite];
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes{
    //NSLog(@"%lld,%lld",fileOffset,expectedTotalBytes);
}

@end
