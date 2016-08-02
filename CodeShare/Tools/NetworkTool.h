//
//  NetworkTool.h
//  CodeShare
//
//  Created by 段登志 on 16/8/2.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkTool : NSObject


//需求分析
//我们一般在请求网络数据时，需要什么？
//网址，参数对
//我们想要得到什么
//请求到数据
//因为网络请求是异步操作，所以我们获取到的数据不能直接返回，要用block回调

//这个里面没有失败的回调，我们有可能需要在外面处理失败后的动作
//我们这个类，仅仅只是作为一个帮助类，不需要具体的对象去做某件事
//如果我们需要请求失败的回调，具体需要什么东西
//1.成功还是失败 2.失败的原因

//我们可以封装成像 AFNetworking 那样成功和失败分别走两个block，成功的block 返回的是获取到的数据，失败的block 返回的是失败原因。
//我们也可以封装到一个block，返回成功或者失败和具体的数据

//我们在做公司项目的时候，会发现我们的接口地址都是统一的

+ (void)getDataWithParameters:(NSDictionary *)parameters completeBlock:(void (^)(BOOL success, id result))complete;


@end
