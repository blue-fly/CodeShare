//
//  CSTriangleView.m
//  CodeShare
//
//  Created by 段登志 on 16/8/9.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSTriangleView.h"

@implementation CSTriangleView

//如果想自定义视图的形状,需要重写 - (void)drawRect:(CGRect)rect,我们在实现这个方法时，不用去调用父类方法
//如果没有特殊需求，就千万不要调用父类方法
//这个方法传入的 rect参数，其实就是这个视图的 bounds
- (void)drawRect:(CGRect)rect {
    
    //1.绘制之前，要先获取到当前的图形上下文（先准备画布）
    //UIGraphicsGetCurrentContext（）这个方法，可以在drawRect方法中使用，获取当前图形上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.设置我们的画笔的参数
    CGContextSetLineWidth(context, 2.0f);//设置线的宽度
    CGContextSetStrokeColorWithColor(context, WArcColor.CGColor);//设置线的颜色
    //3.开始划线，先找到一个点
    //先创建一条可变的线条（相当于划线的时候，先创建一条线，然后设置它的起始点和终点）
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, rect.size.width/2, 0);
    
    //再将画笔移动到终点（在起点和终点画一条线）
    //我们设置的点其实是笔触的中心点，所以有时需要减去画笔的粗细的一半
    CGPathAddLineToPoint(path, nil, 0, rect.size.height - 1);
    
    //再画接下来的线
    CGPathAddLineToPoint(path, nil, rect.size.width, rect.size.height - 1);
    
    CGPathAddLineToPoint(path, nil, rect.size.width/2, 0);
    
    //4.我们还需要将线手动添加到画布上
    CGContextAddPath(context, path);
    
    //5.提交绘图
    CGContextDrawPath(context, kCGPathStroke);
    
    //6.要把路径给释放掉
    CGPathRelease(path);
}


@end
