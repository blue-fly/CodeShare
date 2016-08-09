//
//  CSTriangleViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSTriangleViewController.h"
#import "CSTriangleView.h"
#import "CSDrawableView.h"

@interface CSTriangleViewController ()

@end

@implementation CSTriangleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"核心绘图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //给视图加上背景图片,默认是拉伸
//    self.view.layer.contents = (id)([UIImage imageNamed:@"视频图标"].CGImage);
    
    //可以将图片先转成color，再设置，默认是平铺
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button2"]];
    
//    self.view.contentMode //可以更改视图的显示模式
    
    //加上自定义的三角形视图
    CSTriangleView *triangle = [[CSTriangleView alloc] initWithFrame:CGRectMake(26, 80, 300, 300)];
    
    [self.view addSubview:triangle];
    
    
    //截图
    //如何给某一个view截图（相当于通过一个view生成一个UIImage）
//    [self saveScreenShotWith:triangle];
    
    
    //添加一个可以在上面画图的view
    CSDrawableView *drawableView = [[CSDrawableView alloc] initWithFrame:CGRectMake(16, 350, 300, 300)];
    [self.view addSubview:drawableView];
    
    drawableView.backgroundColor = WArcColor;
}


- (void)saveScreenShotWith: (UIView *)view {
    
    //先生成一张图片的画布
    //图片的大小，是否保留透明度,放大倍数
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, [UIScreen mainScreen].scale);
    
    //如果是iOS7以后
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
        
    }else {
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
    }
    
    //将图片保存
    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
    
    //将图片保存到本地
    UIImageWriteToSavedPhotosAlbum(screenShot, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    //结束图片画布的绘制
    UIGraphicsEndImageContext();
    
    
}

@end
