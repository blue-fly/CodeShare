//
//  CSCircleView.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSCircleView.h"

@interface CSCircleView ()

//路径，绘制圆圈
@property (nonatomic,strong) UIBezierPath *circlePath;

/** 我们将路径画到这个 layer */
@property (nonatomic,strong) CAShapeLayer *circleLayer;

@end

@implementation CSCircleView

//- (void)drawRect:(CGRect)rect {
//    
//    //1.
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //2.创建一个贝塞尔曲线
//    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2];
//    
//    //设置线条的属性
//    bezierPath.lineWidth = 2.0f;
//    CGContextSetFillColorWithColor(context, WArcColor.CGColor);
//    
//    
//    //3.
//    CGContextAddPath(context, bezierPath.CGPath);
//    
//    //4.
//    CGContextDrawPath(context, kCGPathFillStroke);
//    
//}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        //圆形的路径
        self.circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.height) cornerRadius:frame.size.width/2];
        
        //shapeLayer
        self.circleLayer = [[CAShapeLayer alloc] init];
        
        [self.layer addSublayer:self.circleLayer];
        
        //设置一些属性
        [self.circleLayer setStrokeColor:WArcColor.CGColor];
        
        [self.circleLayer setLineWidth:2.0f];
        
        //iOS 在绘制这个layer时，会按照这个路径来
        [self.circleLayer setPath:self.circlePath.CGPath];
        
        [self.circleLayer setFillColor:[UIColor whiteColor].CGColor];
        
        [self.circleLayer setLineCap:kCALineJoinRound];
        
        //用shapeLayer 可以很方便的设置线条的进度
        [self.circleLayer setStrokeStart:0.0];
        [self.circleLayer setStrokeEnd:0.5];
        
        
        //写一个定时器
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
    }
    
    return self;
}


- (void)changeProgress {
    
    self.progress = WArcNum(100)/100.0;
    
    self.circleLayer.strokeColor = WArcColor.CGColor;
}

- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;
    
    //CALayer 默认是带动画的
    [self.circleLayer setStrokeEnd:progress];
    
}




@end
