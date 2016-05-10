//
//  ComunicationModule.m
//  yande.re
//
//  Created by YuJie on 16/4/11.
//  Copyright © 2016年 YuJie. All rights reserved.
//

#import "ComunicationModule.h"

@implementation ComunicationModule
-(void)RequestAPI:(NSString *)url Parameter:(NSDictionary *)param
{
   
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:param progress:^(NSProgress *  downloadProgress){
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             [_delegate SuccessCallback:dic];
         }
        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.delegate FailureCallback:error];
       
        }];
}
-(void)RequestAPI:(NSString *)url Parameter:(NSDictionary *)param withBlock:(void (^)(NSDictionary *Result))block
{
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:param progress:^(NSProgress *  downloadProgress){
        
    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
             if(block)
             {
                 block(dic);
             }
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"%@",error);
             block(nil);
             
         }];
}
@end
