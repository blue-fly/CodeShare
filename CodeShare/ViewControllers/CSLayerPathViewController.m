//
//  CSLayerPathViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSLayerPathViewController.h"

#import "CSCircleView.h"
#import "CSClockView.h"
@interface CSLayerPathViewController ()

@end

@implementation CSLayerPathViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加一个圆形进度条
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Layer Path";

    CSCircleView *circle1 = [[CSCircleView alloc] initWithFrame:CGRectMake(20, 80, 100, 100)];
    
    [self.view addSubview:circle1];
    
    CSCircleView *circle2 = [[CSCircleView alloc] initWithFrame:CGRectMake(220, 80, 150, 150)];
    
    [self.view addSubview:circle2];
    
    //做一个钟表
    CSClockView *clock1 = [[CSClockView alloc] initWithFrame:CGRectMake(100, 180, 150, 150)];
    
    [self.view addSubview:clock1];
    
    
}

@end
