//
//  DataSouce.h
//  yande.re
//
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "API.h"
#import "ComunicationModule.h"
typedef NS_ENUM (NSInteger,PostCycle)
{
    LastMonth,
    LastDay,
    LastWeek,
    Default
    
};
@protocol DataSouceDelegate <NSObject>

-(void)DataCallback:(NSArray *)array;

@end

@interface DataSouce : NSObject<CommunicationDelegate>
@property (nonatomic,strong) id delegate;
-(void)GetPostListForCycle:(NSInteger)PostCycle Param:(NSDictionary *)param;
-(void)GetPoolsByParam:(NSDictionary *)param;
@end
