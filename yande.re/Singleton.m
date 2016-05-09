//
//  Singleton.m
//  yande.re
//
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
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
