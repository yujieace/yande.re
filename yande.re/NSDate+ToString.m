//
//  NSDate+ToString.m
//  SanyaCard
//
//  Created by 於杰 on 15/10/13.
//  Copyright © 2015年 於杰. All rights reserved.
//

#import "NSDate+ToString.h"

@implementation NSDate(ToString)
-(NSString *)ToString:(NSString *)Format
{
    NSDate *date=self;
    NSDateFormatter *dateformat=[[NSDateFormatter alloc] init];
    dateformat.dateFormat=Format;
    return [dateformat stringFromDate:date];

}
+(NSDate *)ReviseDate
{
    NSDate *date=[NSDate date];
    NSTimeZone *zone=[NSTimeZone  systemTimeZone];
    NSInteger interval=[zone secondsFromGMTForDate:date];
    date=[NSDate dateWithTimeInterval:interval sinceDate:date];
    return date;
}
+(NSDate*)StringToDate:(NSString *)Format Date:(NSString *)date
{
    NSDateFormatter *formater=[[NSDateFormatter alloc] init];
    formater.dateFormat=Format;
    return  [formater dateFromString:date];
}
@end
