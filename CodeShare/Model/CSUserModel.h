//
//  CSUserModel.h
//  CodeShare
//
//  Created by 段登志 on 16/8/3.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUserModel : NSObject

//我们通常都将用户当成一个Model来看待 ，那么用户是否登录，就需要我们封装一个方法，因为在我们的程序整个生命周期内，很可能只会创建一个用户对象，所以我们用类方法判断就可以了
+ (BOOL)isLogin;

+ (instancetype)sharedUser;

//封装给外部两个方法
+ (void)loginWithInfo:(NSDictionary *)userInfo;
+ (void)logOff;



@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *name;

@end
