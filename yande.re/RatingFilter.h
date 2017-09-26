//
//  RatingFilter.h
//  yande.re
//  评级过滤，评价post是否符合分级
//  Created by YuJie on 16/4/12.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RatingFilter : NSObject
+(BOOL)Filter:(NSDictionary *)param;/**>判断post是否应该符合评级*/
+(NSString *)RatingLevel:(NSDictionary *)param;/**>获取post评级*/
+(BOOL)isProtectOn;/**>获取评级保护是否开启*/
@end
