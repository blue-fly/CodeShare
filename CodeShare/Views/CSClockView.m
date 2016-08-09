//
//  CSClockView.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSClockView.h"


@interface CSClockView ()

//时针
@property(nonatomic, strong) CAShapeLayer *hourShape;
//分针
@property(nonatomic, strong) CAShapeLayer *minutesShape;
//秒针
@property(nonatomic, strong) CAShapeLayer *secondShape;
//表盘
@property (nonatomic,strong) CAShapeLayer *clockShape;

@end

@implementation CSClockView



- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUpLayers];
        
        [self setUpTimes];
    }
    
    return self;
}

- (void)setUpLayers {
    
    //先画表盘
    self.clockShape = [CAShapeLayer layer];
    self.clockShape.lineWidth = 2.0f;
    self.clockShape.strokeColor = WArcColor.CGColor;
    self.clockShape.fillColor = [UIColor whiteColor].CGColor;
    
    
    UIBezierPath *clockPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width/2];
    
    self.clockShape.path = clockPath.CGPath;
    
    [self.layer addSublayer:self.clockShape];
    
    //再画时针,应该是最短的，最粗的
    self.hourShape = [CAShapeLayer layer];
    self.hourShape.lineWidth = 4.0f;
    self.hourShape.strokeColor = WArcColor.CGColor;
    //是这个layer的锚点
    self.hourShape.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    UIBezierPath *hourPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, -self.frame.size.height/2 + 16, 2, self.frame.size.width/2 - 16)];
    
    self.hourShape.path = hourPath.CGPath;
    
    [self.layer addSublayer:self.hourShape];
    
    //再画一个分针
    self.minutesShape = [CAShapeLayer layer];
    self.minutesShape.lineWidth = 3.0f;
    self.minutesShape.strokeColor = WArcColor.CGColor;
    
    self.minutesShape.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    UIBezierPath *minutePath = [UIBezierPath bezierPathWithRect:CGRectMake(0, -self.frame.size.height/2 + 10, 1.5, self.frame.size.height/2 - 10)];
    
    self.minutesShape.path = minutePath.CGPath;
    
    [self.layer addSublayer:self.minutesShape];
    
    //最后我们将秒针画上
    self.secondShape = [CAShapeLayer layer];
    self.secondShape.lineWidth = 1.0f;
    self.secondShape.strokeColor = WArcColor.CGColor;
    
    self.secondShape.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    
    UIBezierPath *secondPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, -self.frame.size.height/2 + 4, 1.5, self.frame.size.height/2 - 4)];
    
    self.secondShape.path = secondPath.CGPath;
    
    [self.layer addSublayer:self.secondShape];
}

- (void)setUpTimes {
    
    //有一个毫秒级的定时器，每秒钟会调用60次
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshTime)];
    //如果我们设置了一个CADisplayLink,必须要将他加入到runloop才能生效
    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)refreshTime {
    
    //要根据当前的时间，设置我们的指针指向的位置
    NSDate *currentDate = [NSDate date];
    //取得当前的时分秒
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //日期组成,用这种方式，可以很简单的取出精确的时分秒等等
    NSDateComponents *components = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:currentDate];
    
    //取出之后，将时分秒转换为弧度，并且将指针旋转
    [self.hourShape setAffineTransform:CGAffineTransformMakeRotation(components.hour / 12.0 * 2 * M_PI)];
    
    [self.minutesShape setAffineTransform:CGAffineTransformMakeRotation(components.minute / 60.0f * 2 * M_PI)];
    
    [self.secondShape setAffineTransform:CGAffineTransformMakeRotation(components.second / 60.0f * 2 * M_PI)];
    
    self.clockShape.strokeColor = WArcColor.CGColor;
    
}


@end
