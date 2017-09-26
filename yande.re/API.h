//
//  API.h
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#ifndef API_h
#define API_h

#define API_PREFIX @"https://yande.re/"
//#define API_PREFIX @"http://www.konachan.net/"
#define API_GET_TAGS [API_PREFIX stringByAppendingString:@"tag.json"]
#define API_GET_POOL [API_PREFIX stringByAppendingString:@"pool.json"]
#define API_GET_POST [API_PREFIX stringByAppendingString:@"post.json"]
#define API_SHOW_POOL [API_PREFIX stringByAppendingString:@"pool/show.json"]
#define API_POP_DAY [API_PREFIX stringByAppendingString:@"post/popular_by_day.json"]
#define API_POP_WEEK [API_PREFIX stringByAppendingString:@"post/popular_by_week.json"]
#define API_POP_MONTH [API_PREFIX stringByAppendingString:@"post/popular_by_month.json"]

#endif /* API_h */
