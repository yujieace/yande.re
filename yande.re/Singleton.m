//
//  Singleton.m
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "Singleton.h"
static NSMutableDictionary *Shared;
@implementation Singleton

+(NSMutableDictionary *)GetSharedData
{
    if(Shared==nil)
    {
        Shared=[[NSMutableDictionary alloc] init];
    }
    return Shared;
}
@end
