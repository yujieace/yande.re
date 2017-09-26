//
//  PreferenceModule.m
//  yande.re
//
//  Created by YuJie on 16/4/14.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "PreferenceModule.h"
#import <FMDB.h>
#import "NSDate+ToString.h"
#import <BmobSDK/Bmob.h>
#define PreferenceDB [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]  stringByAppendingString:@"/Preference.DB"]
@implementation PreferenceModule
-(instancetype)init
{
    DB=[FMDatabase databaseWithPath:PreferenceDB];
    [DB open];
    return self;
}

-(void)dealloc
{
    [DB close];
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
-(BOOL)isPostLiked:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    [self CheckPostTB];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM FAVOURITEPOSTTB where ID='%@'",ID];
    FMResultSet *set=[DB executeQuery:sql];
    NSInteger count=0;
    if([set next])
    {
        count++;
    }
    if(count>0)
    {
        return YES;
    }
    else
        return NO;
    
}

-(BOOL)isPoolLiked:(NSDictionary *)pool
{
    NSString *ID=[NSString stringWithFormat:@"%@",[pool valueForKey:@"id"]];
    [self CheckPoolTB];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM FAVOURITEPOOLTB where ID='%@'",ID];
    FMResultSet *set=[DB executeQuery:sql];
    NSInteger count=0;
    if([set next])
    {
        count++;
    }
    if(count>0)
    {
        return YES;
    }
    else
        return NO;
}
-(BOOL)AddPostLiked:(NSDictionary *)post
{
    if([self isPostLiked:post])
        return YES;
    
    
    
    BmobQuery *query=[BmobQuery queryWithClassName:@"favourite"];
    [query whereKey:@"id" equalTo:[post[@"id"] stringValue]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       if(array.count>0)
       {
           for (BmobObject *temp in array) {
               [temp setObject:@0 forKey:@"Deleted"];
               [temp updateInBackground];
           }
       }
        else
        {
            BmobObject *obj=[BmobObject objectWithClassName:@"favourite"];
            NSData *jsonData=[NSJSONSerialization dataWithJSONObject:post  options:NSJSONWritingPrettyPrinted error:nil];
            [obj setObject:[post[@"id"] stringValue] forKey:@"id"];
            [obj setObject:@0 forKey:@"Deleted"];
            [obj setObject:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] forKey:@"PostData"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
            }];
        }
    }];
   

    return [self writePostToDB:post];
}

-(BOOL)writePostToDB:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    if([self isPostLiked:post])
        return YES;
    NSData *INFO=[NSJSONSerialization dataWithJSONObject:post options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json=[INFO base64EncodedStringWithOptions:NSUTF8StringEncoding];
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO FAVOURITEPOSTTB VALUES('%@','%@','%@')",ID,[[NSDate ReviseDate] ToString:@"yyyyMMddHHmmss"],json];
    BOOL result=[DB executeUpdate:sql];
    [DB commit];
    return result;
}
-(BOOL)RemovePostLiked:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    
    if([self isPostLiked:post])
    {
        BOOL result=[self removePost:post];
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"favourite"];
        [bquery whereKey:@"id" equalTo:ID];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                [obj setObject:@1 forKey:@"Deleted"];
                [obj updateInBackground];
            }
        }];
        return  result;
    }
    else
        return YES;
}

-(BOOL)removePost:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM FAVOURITEPOSTTB WHERE ID='%@'",ID];
    BOOL result= [DB executeUpdate:sql];
    [DB commit];
    return result;
}

-(BOOL)AddPoolLiked:(NSDictionary *)pool
{
    NSString *ID=[NSString stringWithFormat:@"%@",[pool valueForKey:@"id"]];
    if([self isPoolLiked:pool])
        return YES;
    NSData *INFO=[NSJSONSerialization dataWithJSONObject:pool options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json=[INFO base64EncodedStringWithOptions:NSUTF8StringEncoding];
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO FAVOURITEPOOLTB VALUES('%@','%@','%@')",ID,[[NSDate ReviseDate] ToString:@"yyyyMMddHHmmss"],json];
    BOOL result=[DB executeUpdate:sql];
    [DB commit];
    return  result;
    
}
-(BOOL)RemovePoolLiked:(NSDictionary *)pool
{
    NSString *ID=[NSString stringWithFormat:@"%@",[pool valueForKey:@"id"]];
    if([self isPoolLiked:pool])
    {
        NSString *sql=[NSString stringWithFormat:@"DELETE  FROM FAVOURITEPOOLTB WHERE ID='%@'",ID];
        BOOL result= [DB executeUpdate:sql];
        [DB commit];
        return result;
    }
    else
        return YES;
}
-(BOOL)AddPostBlackList:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    if([self isPostBlackListed:post])
        return YES;
    NSData *INFO=[NSJSONSerialization dataWithJSONObject:post options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json=[INFO base64EncodedStringWithOptions:NSUTF8StringEncoding];
    NSString *sql=[NSString stringWithFormat:@"INSERT INFO BLACKPOSTLIST VALUES('%@','%@','%@')",ID,[[NSDate ReviseDate] ToString:@"yyyyMMddHHmmss"],json];
    BOOL result=[DB executeUpdate:sql];
    [DB commit];
    return result;
}
-(BOOL)AddPoolBlackList:(NSDictionary *)pool
{
    NSString *ID=[NSString stringWithFormat:@"%@",[pool valueForKey:@"id"]];
    if ([self isPoolBlackListed:pool]) {
        return YES;
    }
    NSData *INFO=[NSJSONSerialization dataWithJSONObject:pool options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json=[INFO base64EncodedStringWithOptions:NSUTF8StringEncoding];
    BOOL result=[DB executeUpdate:@"INSERT INFO BLACKPOOLLIST VALUES('%@','%@','%@')",ID,[[NSDate ReviseDate] ToString:@"yyyyMMddHHmmss"],json];
    [DB commit];
    return result;
}

-(BOOL)isPostBlackListed:(NSDictionary *)post
{
    NSString *ID=[NSString stringWithFormat:@"%@",[post valueForKey:@"id"]];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM BLACKPOSTLIST WHERE ID='%@'",ID];
    FMResultSet *set=[DB executeQuery:sql];
    NSInteger *count=0;
    if([set next])
    {
        count++;
    }
    if(count>0)
    {
        return YES;
    }
    else
        return NO;
}

-(BOOL)isPoolBlackListed:(NSDictionary *)pool
{
    NSString *ID=[NSString stringWithFormat:@"%@",[pool valueForKey:@"id"]];
    [self CheckPoolBlackTB];
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM BLACKPOOLLIST WHERE ID='%@'",ID];
    FMResultSet *set=[DB executeQuery:sql];
    NSInteger *count=0;
    if([set next])
    {
        count++;
    }
    
    if(count>0)
    {
        return YES;
    }
    else
        return NO;
}



-(void)CheckPostTB
{
    if(![self Checktable:@"FAVOURITEPOSTTB"])
    {
        [DB executeUpdate:@"CREATE TABLE FAVOURITEPOSTTB(ID varchar,DateTime varchar,INFO text)"];
    }
}

-(void)CheckPoolTB
{
    if(![self Checktable:@"FAVOURITEPOOLTB"])
    {
        [DB executeUpdate:@"CREATE TABLE FAVOURITEPOOLTB(ID varchar,DateTime varchar,INFO text)"];
    }
}
-(void)CheckPostBlackTB
{
    if(![self Checktable:@"BLACKPOSTLIST"])
    {
        [DB executeUpdate:@"CREATE TABLE BLACKPOSTLIST(ID text,DateTime varchar,INFO text)"];
    }
}

-(void)CheckPoolBlackTB
{
    if(![self Checktable:@"BLACKPOOLLIST"])
    {
        [DB executeUpdate:@"CREATE TABLE BLACKPOOLLIST(ID text,DateTime varchar,INFO text)"];
    }

}
-(NSArray *)GetFravouritePostList
{
    [self CheckPostTB];
    NSString *sql=@"SELECT * FROM FAVOURITEPOSTTB";
    FMResultSet *set=[DB executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while([set next])
    {
        NSString *json=[set stringForColumn:@"INFO"];
        NSData *decodeData=[[NSData alloc]initWithBase64EncodedString:json options:0];
        NSDate *datetime=[NSDate StringToDate:@"yyyyMMddHHmmss" Date:[set stringForColumn:@"DateTime"]];

        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *post=[[NSMutableDictionary alloc] init];
        [post setObject:datetime forKey:@"datetime"];
        [post setObject:dic forKey:@"info"];
        [array addObject:post];
    }
    return array;
}
-(NSArray *)GetFravouritePoolList
{
    [self CheckPostTB];
    NSString *sql=@"SELECT * FROM FAVOURITEPOOLTB";
    FMResultSet *set=[DB executeQuery:sql];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while([set next])
    {
        
        NSString *json=[set stringForColumn:@"INFO"];
        NSData *decodeData=[[NSData alloc]initWithBase64EncodedString:json options:0];
        NSDate *datetime=[NSDate StringToDate:@"yyyyMMddHHmmss" Date:[set stringForColumn:@"DateTime"]];
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:decodeData options:NSJSONReadingMutableLeaves error:nil];
        NSMutableDictionary *pool=[[NSMutableDictionary alloc] init];
        [pool setObject:datetime forKey:@"datetime"];
        [pool setObject:dic forKey:@"info"];
        [array addObject:pool];
    }
    return array;

}
@end
