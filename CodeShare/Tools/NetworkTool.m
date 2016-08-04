//
//  NetworkTool.m
//  CodeShare
//
//  Created by 段登志 on 16/8/2.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "NetworkTool.h"
#import <AFNetworking.h>

#ifdef DEBUG //DEBUG 是程序自带的默认存在的一个宏定义，我们平时运行都是在这种方式下

static NSString *baseUrl = @"http://10.30.152.134/PhalApi/Public/CodeShare/";
//接口列表地址
//http://10.30.152.134/PhalApi/Public/CodeShare/listAllApis.php


#else

static NSString *baseUrl = @"https://www.1000phone.tk";
//接口列表地址


#endif


@implementation NetworkTool

//为了防止我们的应用频繁获取网络数据的时候，创建的sessionManager过多，会大量消耗手机资源，我们最好封装为一个单例，获取网络数据只用到这一个对象
+ (AFHTTPSessionManager *)sharedManager {
    
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:QFAppBaseURL]];
        
        //设置请求的超时时间
        manager.requestSerializer.timeoutInterval  = 5;
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"text/html",@"text/xml",@"application/json", nil];
    });
    
    return manager;
}


+ (void)getDataWithParameters:(NSDictionary *)parameters completeBlock:(void (^)(BOOL, id))complete{
    
    //用AFNetworking做网络请求的时候，可以有一个小优化，可以缓存我们的地址
    //为什么这里算是一个优化？
    //我们这里用BaseUrl 生成 sessionManager 就相当于告诉 AFNetworking,以后我们请求数据，都是从这个服务器，那么AFNetworking会把这个服务器的地址缓存起来
    
    [[self sharedManager] POST:@"" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        
        NSNumber *serviceCode = [responseObject objectForKey:@"ret"];
        
        if ([serviceCode isEqualToNumber:@200]) {
            //证明没有服务错误
            
            NSDictionary *retData = [responseObject objectForKey:@"data"];
            
            NSNumber *dataCode = [retData objectForKey:@"code"];
            
            if ([dataCode isEqualToNumber:@0]) {
                //证明返回的数据没有错误
                
                NSDictionary *userInfo = [retData objectForKey:@"data"];
            
                
                //先判断是否有完成请求的处理 block 如果有，就传回
                if (complete) {
                    complete(YES,userInfo);
                }
                
            }else {
                NSString *dataMessage = [retData objectForKey:@"msg"];
                
                NSLog(@"%@",dataMessage);
                
                if (complete) {
                    complete(NO,dataMessage);
                }
            }
            
            
        }else {
            NSString *serviceMessage = [responseObject objectForKey:@"msg"];
            NSLog(@"serviceMessage,%@",serviceMessage);
            
            if (complete) {
                complete(NO,serviceMessage);
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error.localizedDescription);
        
        if (complete) {
            complete(NO,error.localizedDescription);
        }
    }];

    
}

@end
