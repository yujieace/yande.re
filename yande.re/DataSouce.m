//
//  DataSouce.m
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "DataSouce.h"

@implementation DataSouce
-(void)GetPostListForCycle:(NSInteger)PostCycle Param:(NSDictionary *)param
{
    ComunicationModule *com=[[ComunicationModule alloc] init];
    com.delegate=self;
    switch (PostCycle) {
        case LastDay:
        {
            [com RequestAPI:API_POP_DAY Parameter:param];
        }
            break;
            
          case LastMonth:
        {
            [com RequestAPI:API_POP_MONTH Parameter:param];
        }
            break;
            
            case LastWeek:
        {
            [com RequestAPI:API_POP_WEEK Parameter:param];
        }
            break;
        case Default:
        {
            [com RequestAPI:API_GET_POST Parameter:param];
        }
            break;
        default:
        {
        }
            break;
    }
    
}
-(void)GetPoolsByParam:(NSDictionary *)param
{
    ComunicationModule *com=[[ComunicationModule alloc] init];
    com.delegate=self;
    [com RequestAPI:API_GET_POOL Parameter:param];
}
-(void)SuccessCallback:(id)object
{
    NSMutableArray *arr=[NSMutableArray array];
    for (NSDictionary *post in object) {
        NSMutableDictionary *temp=[NSMutableDictionary dictionaryWithDictionary:post];
        NSString *sample=[temp valueForKey:@"sample_url"];
        if(![sample hasPrefix:@"http"])
        {
            sample=[NSString stringWithFormat:@"http:%@",sample];
            [temp setObject:sample forKey:@"sample_url"];
        }
        
        
        NSString *preview=[temp valueForKey:@"preview_url"];
        if(![preview hasPrefix:@"http"])
        {
            preview=[NSString stringWithFormat:@"http:%@",preview];
            [temp setObject:preview forKey:@"preview_url"];
        }
        
        
        NSString *file=[temp valueForKey:@"file_url"];
        if(![file hasPrefix:@"http"])
        {
            file=[NSString stringWithFormat:@"http:%@",file];
            [temp setObject:file forKey:@"file_url"];
        }
        
        NSString *jpg=[temp valueForKey:@"jpeg_url"];
        if(![jpg hasPrefix:@"http"])
        {
            jpg=[NSString stringWithFormat:@"http:%@",file];
            [temp setObject:file forKey:@"jpeg_url"];
        }
        
        [arr addObject:temp];
    }
    [_delegate DataCallback:arr];
}

-(void)FailureCallback:(id)object
{
    NSLog(@"%@",object);
    [_delegate DataCallback:nil];
}
@end
