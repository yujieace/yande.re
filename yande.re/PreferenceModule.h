//
//  PreferenceModule.h
//  yande.re
//
//  Created by 於杰 on 16/4/14.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>
@interface PreferenceModule : NSObject
{
    FMDatabase *DB;
}
-(instancetype)init;
-(BOOL)isPostLiked:(NSDictionary *)post;/**>判断Post是否已收藏*/
-(BOOL)isPoolLiked:(NSDictionary *)pool;/**>判断Pool是否已收藏*/
-(BOOL)AddPostLiked:(NSDictionary *)post;/**>添加Post到收藏*/
-(BOOL)RemovePostLiked:(NSDictionary *)post;/**>移除Post收藏*/
-(BOOL)AddPoolLiked:(NSDictionary *)pool;/**>添加Pool到收藏*/
-(BOOL)RemovePoolLiked:(NSDictionary *)pool;/**>移除Pool收藏*/
-(BOOL)AddPostBlackList:(NSDictionary *)post;/**>添加Post黑名单（举报，拉黑）*/
-(BOOL)AddPoolBlackList:(NSDictionary *)pool;/**>添加Pool黑名单（举报，拉黑）*/
-(BOOL)isPostBlackListed:(NSDictionary *)post;/**>判断Post是否已拉黑，评级系统用于判断依据之一*/
-(BOOL)isPoolBlackListed:(NSDictionary *)pool;/**>判断Pool是否已拉黑，评级系统用于判断依据之一*/
-(NSArray *)GetFravouritePostList;/**>获取收藏POST列表*/
-(NSArray *)GetFravouritePoolList;/**>获取收藏POOL列表*/
@end
