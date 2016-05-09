//
//  NSnull+Json.m
//  Sanya University
//
//  Created by 於杰 on 16/4/6.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import "NSnull+Json.h"

@implementation NSNull(NSnull_Json)
- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }
@end
