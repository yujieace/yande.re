//
//  ImageSaveDelegate.m
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 hnzc. All rights reserved.
//

#import "ImageSaveDelegate.h"
#import <UIKit/UIKit.h>
#import "ViewController+Message.h"
@interface ImageSaveDelegate()
{
    UIImpactFeedbackGenerator *feedBack;
}
@end
@implementation ImageSaveDelegate
+(ImageSaveDelegate *)sharedInstance{
    static ImageSaveDelegate *delegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        delegate = [[ImageSaveDelegate alloc] init];
    });
    return delegate;
    
}

-(instancetype)init{

    self=[super init];
    feedBack = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
    [feedBack prepare];
    return self;
}

- (void)downloadProcess:(DownloadTask *)task current:(NSUInteger)current totol:(NSUInteger)total {
   
}

- (void)downloadTaskFinished:(DownloadTask *)task state:(BOOL)state {
    if(state){
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:task.filePath];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController ShowMessage:@"下载失败" InSeconds:1];
    }
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [[UIApplication sharedApplication].keyWindow.rootViewController ShowMessage:@"下载成功已保存到相册" InSeconds:1];
        [feedBack impactOccurred];
    }else
    {
        [[UIApplication sharedApplication].keyWindow.rootViewController ShowMessage:@"保存失败" InSeconds:1];
    }
    
    
}

@end
