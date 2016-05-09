//
//  TagsManager.h
//  yande.re
//
//  Created by 於杰 on 16/4/28.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface TagsManager : NSObject
{
    FMDatabase *DB;
}
-(instancetype)init;
-(void)installTagsDataBase;
-(NSArray *)QuerynameLike:(NSString *)name;
-(void)UpdateNewset;
-(void)UpdatePopularTag;
-(NSArray *)SelectTop:(NSInteger)top;
-(NSArray *)SelectNewset:(NSInteger)top;
@end
