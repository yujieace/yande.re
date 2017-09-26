//
//  RatingFilter.m
//  yande.re
//
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "RatingFilter.h"
#import "PreferenceModule.h"
@implementation RatingFilter
+(BOOL)Filter:(NSDictionary *)param
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ratesetting=[user valueForKey:@"rating"];
    PreferenceModule *preference=[[PreferenceModule alloc] init];
    if(ratesetting==nil)
    {
        ratesetting=[[NSMutableDictionary alloc] init];
        [ratesetting setValue:@"0" forKey:@"age"];
        [user setObject:[ratesetting copy] forKey:@"rating"];
        [user synchronize];
    }
    if([[ratesetting valueForKey:@"age"] integerValue]>=18&&![preference isPostBlackListed:param])
    {
        return true;
    }
    else
    {
        if([[param valueForKey:@"rating"] isEqualToString:@"s"]&&![preference isPostBlackListed:param])
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}

+(NSString *)RatingLevel:(NSDictionary *)param
{
    if([[param valueForKey:@"rating"] isEqualToString:@"s"])
        return  @"Safe";
    else if ([[param valueForKey:@"rating"] isEqualToString:@"q"])
        return @"Questionable";
    else if ([[param valueForKey:@"rating"] isEqualToString:@"e"])
        return @"Explicit";
    else
        return @"Unknown";
}

+(BOOL)isProtectOn
{
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *ratesetting=[user valueForKey:@"rating"];
    if(ratesetting==nil)
    {
        ratesetting=[[NSMutableDictionary alloc] init];
        [ratesetting setValue:@"0" forKey:@"age"];
        [user setObject:[ratesetting copy] forKey:@"rating"];
        [user synchronize];
    }
    if([[ratesetting valueForKey:@"age"] integerValue]>=18)
    {
        return false;
    }
    else
    {
        return true;
    }

}
@end
