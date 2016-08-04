//
//  CSUserModel.m
//  CodeShare
//
//  Created by 段登志 on 16/8/3.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSUserModel.h"

@implementation CSUserModel

+ (BOOL)isLogin {
    return [CSUserModel sharedUser].ID;
}

+ (instancetype)sharedUser {
    
    static CSUserModel *sharedUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        sharedUser = [[super allocWithZone:NULL] init];
        
    });
    
    return sharedUser;
}

//模型自定义属性映射
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"ID": @"id"
             };
}

//KVC
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
//    
//}




@end
