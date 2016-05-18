//
//  TagsManager.m
//  yande.re
//
//  Created by YuJie on 16/4/28.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "TagsManager.h"
#import <FMDB.h>
#import "API.h"
#import "ComunicationModule.h"
#define TagsDB [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/Tags.DB"]
@implementation TagsManager

-(instancetype)init
{
    DB=[FMDatabase databaseWithPath:TagsDB];
    [DB open];
    return self;
}
-(void)installTagsDataBase
{
    BOOL isTable=[self Checktable:@"tags"];
    if(!isTable)
    {
        NSString *sql=@"create table tags(ID varchar,name text,count int,info text)";
        BOOL result=[DB executeUpdate:sql];
        if(result)
        {
            //初始化tags数据
            NSString *path=[[NSBundle mainBundle] pathForResource:@"tags" ofType:@".txt"];
            NSString *json=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            
            NSData *jsondata=[json dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *array=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
            for (NSDictionary *temp in array) {
                NSData *infodata=[NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
                NSString *info=[[NSString alloc] initWithData:infodata encoding:NSUTF8StringEncoding];
                NSString *insertsql=[NSString stringWithFormat:@"insert into tags values('%@','%@',%@,'%@');",[temp valueForKey:@"id"],[temp valueForKey:@"name"],[temp valueForKey:@"count"],info];
               [DB executeUpdate:insertsql];
            }
             
        }
        else
        {
            NSLog(@"初始化tags数据库失败");
        }
    }
}


-(NSArray *)QuerynameLike:(NSString *)name
{
    [self checkTags];
    NSString *sql=[NSString stringWithFormat:@"select * from tags where name like '%%%@%%' limit 0,5",name];
    FMResultSet *set=[DB executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while([set next])
    {
        NSString *json=[set stringForColumn:@"info"];
        NSData *jsondata=[json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        [array addObject:dic];
    }
    
    return array;
    
}

-(void)UpdateNewset
{
    //更新最新100个tags
    [self checkNewest];
    NSDictionary *param=[[NSDictionary alloc] initWithObjectsAndKeys:@"200",@"limit",@"date",@"order", nil];
    ComunicationModule *com=[[ComunicationModule alloc] init];
    [com RequestAPI:API_GET_TAGS Parameter:param withBlock:^(NSDictionary *Result) {
        NSArray *array=(NSArray *)Result;
        if([DB executeUpdate:@"delete from newtags"])
        {
            for (NSDictionary *temp in array) {
                NSData *infodata=[NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
                NSString *info=[[NSString alloc] initWithData:infodata encoding:NSUTF8StringEncoding];
                NSString *insertsql=[NSString stringWithFormat:@"insert into newtags values('%@','%@',%@,'%@');",[temp valueForKey:@"id"],[temp valueForKey:@"name"],[temp valueForKey:@"count"],info];
                [DB executeUpdate:insertsql];
            }
            NSLog(@"最新tag更新完成");
        }
    }];
    
}
-(void)UpdatePopularTag
{
    [self checkTags];
    NSDictionary *param=[[NSDictionary alloc] initWithObjectsAndKeys:@"1000",@"limit",@"count",@"order", nil];
    ComunicationModule *com=[[ComunicationModule alloc] init];
    [com RequestAPI:API_GET_TAGS Parameter:param withBlock:^(NSDictionary *Result) {
        NSArray *array=(NSArray *)Result;
        if([DB executeUpdate:@"delete from tags"])
        {
            for (NSDictionary *temp in array) {
                NSData *infodata=[NSJSONSerialization dataWithJSONObject:temp options:NSJSONWritingPrettyPrinted error:nil];
                NSString *info=[[NSString alloc] initWithData:infodata encoding:NSUTF8StringEncoding];
                NSString *insertsql=[NSString stringWithFormat:@"insert into tags values('%@','%@',%@,'%@');",[temp valueForKey:@"id"],[temp valueForKey:@"name"],[temp valueForKey:@"count"],info];
                [DB executeUpdate:insertsql];
            }
            NSLog(@"最热tag更新完成");
        }
    }];
}
-(BOOL)checkTags
{
    if(![self Checktable:@"tags"])
    {
        [self installTagsDataBase];
    }
    return YES;

}
-(NSArray *)SelectNewset:(NSInteger)top
{
    NSString *sql=[NSString stringWithFormat:@"select * from newtags order by count DESC limit 0,%ld",(long)top];
    FMResultSet *set=[DB executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([set next]) {
        NSString *json=[set stringForColumn:@"info"];
        NSData *jsondata=[json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        [array addObject:dic];
    }
    
    return array;
}
-(BOOL)checkNewest
{
    if(![self Checktable:@"newtags"])
    {
        NSString *sql=@"create table newtags(ID varchar,name text,count int,info text)";
        return [DB executeUpdate:sql];
    }
    return YES;
}
-(BOOL)Checktable:(NSString *)tableName
{
    FMResultSet *rs = [DB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        if (0 == count)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return NO;
    
}

-(NSArray *)SelectTop:(NSInteger)top
{
    NSString *sql=[NSString stringWithFormat:@"select * from tags order by count DESC limit 0,%ld",(long)top];
    FMResultSet *set=[DB executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([set next]) {
        NSString *json=[set stringForColumn:@"info"];
        NSData *jsondata=[json dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:jsondata options:NSJSONReadingMutableLeaves error:nil];
        [array addObject:dic];
    }
    
    return array;
}
-(void)dealloc
{
    [DB close];
}

@end
