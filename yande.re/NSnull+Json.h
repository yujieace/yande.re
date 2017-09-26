//
//  NSnull+Json.h
//  Sanya University
//
//  Created by YuJie on 16/4/6.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNull(NSnull_Json)
- (NSUInteger)length;

- (NSInteger)integerValue;;

- (float)floatValue;

- (NSString *)description;

- (NSArray *)componentsSeparatedByString:(NSString *)separator;

- (id)objectForKey:(id)key;

- (BOOL)boolValue;

@end
