//
//  DownloadTask.m
//  yande.re
//
//  Created by 於杰 on 2018/5/19.
//  Copyright © 2018年 Yujie All rights reserved.
//

#import "DownloadTask.h"

@implementation DownloadTask
-(instancetype)init
{
    self=[super init];
    self.downloadProcess = 0;
    self.taskState=NO;
    return self;
}
- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.fileName forKey:@"fileName"];
    [aCoder encodeObject:self.filePath forKey:@"filePath"];
    [aCoder encodeObject:self.createDate forKey:@"createDate"];
    [aCoder encodeDouble:self.downloadProcess forKey:@"downloadProcess"];
    [aCoder encodeInteger:self.taskState forKey:@"taskState"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [self init];
    self.url = [aDecoder decodeObjectForKey:@"url"];
    self.filePath=[aDecoder decodeObjectForKey:@"fileName"];
    self.fileName=[aDecoder decodeObjectForKey:@"filePath"];
    self.createDate=[aDecoder decodeObjectForKey:@"createDate"];
    self.downloadProcess=[aDecoder decodeDoubleForKey:@"downloadProcess"];
    self.taskState = [aDecoder decodeIntegerForKey:@"taskState"];
    return self;
}

@end
