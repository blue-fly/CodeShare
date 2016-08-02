//
//  ViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/2.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "NetworkTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"service"] = @"UserInfo.GetInfo";
    parameter[@"uid"] = @"1";
    
    
    [NetworkTool getDataWithParameters:parameter completeBlock:^(BOOL success, id result) {
        
        //虽然我们把成功和失败写到一个block 回调，但是还是需要判断
        if (success) {
            NSLog(@"用户信息  --%@",result);
        }else {
            NSLog(@"失败原因  --%@",result);
        }
    
    
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
