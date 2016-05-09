//
//  NSDate+ToString.h
//  SanyaCard
//
//  Created by 於杰 on 15/10/13.
//  Copyright © 2015年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(ToString)
-(NSString *)ToString:(NSString *)Format;/**<将NSDate对象转换成字符串*/
+(NSDate *)StringToDate:(NSString *)Format Date:(NSString *)date;/**<从字符串转成NSDate*/
+(NSDate *)ReviseDate;/**>获取修正后的时间*/
@end
