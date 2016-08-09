//
//  CSDrawableView.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSDrawableView.h"


@interface CSDrawableView ()

//当前手指所在的点
@property (nonatomic,assign) CGPoint currentPoint;
//上一次手指所在的点
@property (nonatomic,assign) CGPoint prePoint;
//将路径保存起来
@property (nonatomic,assign) CGMutablePathRef drawPath;

@end


@implementation CSDrawableView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        //在初始化方法中将路径创建出来
        self.drawPath = CGPathCreateMutable();
    }
    
    return self;
    
}


//分析一下
//我们要做一个画图软件，（可以保存我们的手指运动轨迹），需要什么
//需要随时知道我们的手指滑动到哪里
//知道手指何时又滑动到哪里


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //1.获取一个画布
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.设置笔触的颜色和粗细
    CGContextSetLineWidth(context, 3.0f);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    //设置画笔开始时候的类型
    CGContextSetLineCap(context, kCGLineCapRound);
    //设置两条线之间交汇的类型
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    
    //3.(划线)，将线条绘制到画布上
    CGContextAddPath(context, self.drawPath);
    
    
    //4.开始绘制
    CGContextDrawPath(context, kCGPathStroke);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //这个方法是在手指当挪到视图上时候调用
    UITouch *touch = [touches anyObject];
    
    //设置currentPoint
    self.currentPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //也需要将touch取出
    UITouch *touch = [touches anyObject];
    //将currentPoint 变成prePoint
    self.prePoint = self.currentPoint;
    //再设置currentPoint
    self.currentPoint = [touch locationInView:self];
    
    //创建两点之间的线
    CGMutablePathRef subPath = CGPathCreateMutable();
    //先将subPath的起始点设置为prePoint
    CGPathMoveToPoint(subPath, nil, self.prePoint.x, self.prePoint.y);

//    CGPathAddLineToPoint(subPath, nil, self.currentPoint.x, self.currentPoint.y);
    
    //在两点之间加入一个二次贝塞尔曲线
    CGPathAddQuadCurveToPoint(subPath, nil, self.prePoint.x, self.prePoint.y, self.currentPoint.x, self.currentPoint.y);
    
    
    //将subPath 加到 self.drawPath 路径之中
    CGPathAddPath(self.drawPath, nil, subPath);
    
    //将subPath释放
    CGPathRelease(subPath);
    
    //手动刷新界面
    [self setNeedsDisplay];
    
}


@end
