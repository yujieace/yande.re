//
//  ImageSaveDelegate.h
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 hnzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadTask.h"
@interface ImageSaveDelegate : NSObject<DownloadTaskDelegate>
+(ImageSaveDelegate *)sharedInstance;
@end
