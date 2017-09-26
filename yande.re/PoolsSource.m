//
//  PoolsSource.m
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "PoolsSource.h"
#import "ComunicationModule.h"
#import "API.h"
@implementation PoolsSource
-(void)StartGetPools:(NSDictionary *)param withBlock:(void (^)(NSMutableArray *Result))block
{
    ComunicationModule *com=[[ComunicationModule alloc] init];
    [com RequestAPI:API_GET_POOL Parameter:param withBlock:^(NSDictionary *Result) {
        NSArray *array=(NSArray*)Result;
        NSMutableArray *source=[[NSMutableArray alloc] init];
        for (NSDictionary *pool in array) {
            NSString *ID=[pool valueForKey:@"id"];
            NSDictionary *idparam=[[NSDictionary alloc] initWithObjectsAndKeys:ID,@"id", nil];
            [com RequestAPI:API_SHOW_POOL Parameter:idparam withBlock:^(NSDictionary *Result) {
                [source addObject:Result];
                if(source.count==array.count)
                    block(source);
            }];
        }
    }];
}

@end
