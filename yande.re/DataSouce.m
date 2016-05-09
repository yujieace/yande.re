//
//  DataSouce.m
//  yande.re
//
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
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
    [_delegate DataCallback:[object allObjects]];
}

-(void)FailureCallback:(id)object
{
    NSLog(@"%@",object);
    [_delegate DataCallback:nil];
}
@end
