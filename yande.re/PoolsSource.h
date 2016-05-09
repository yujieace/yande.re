//
//  PoolsSource.h
//  yande.re
//
//  Created by 於杰 on 16/4/12.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PoolsSource : NSObject
-(void)StartGetPools:(NSDictionary *)param withBlock:(void(^)(NSMutableArray *Result))block;
@end
