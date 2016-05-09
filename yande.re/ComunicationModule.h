//
//  ComunicationModule.h
//  yande.re
//
//  Created by 於杰 on 16/4/11.
//  Copyright © 2016年 於杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface ComunicationModule : NSObject
@property (nonatomic,strong) id delegate;
-(void)RequestAPI:(NSString *)url Parameter:(NSDictionary *)param;

-(void)RequestAPI:(NSString *)url Parameter:(NSDictionary *)param withBlock:(void(^)(NSDictionary *Result))block;

@end

@protocol CommunicationDelegate <NSObject>

@optional
-(void)SuccessCallback:(id)object;
-(void)FailureCallback:(id)object;

@end
