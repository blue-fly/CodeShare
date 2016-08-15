//
//  main.m
//  CodeShare
//
//  Created by 段登志 on 16/8/2.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


//按理说，我们的程序是线性的，当main函数执行完毕，走到最后，程序就会退出，但是我们的程序现在没有运行任何代码，却没有退出，并且能够响应我们的点击，都是因为我们的主程序有一个runlopp
//runloop 就是一个死循环，在循环中执行相应的处理，所以我们的程序不会自己退出
//runloop 中处理的事件，触摸的事件优先级最高
//默认每一个主线程都有一个主runloop，但是只有主线程的runloop是开启的。我们自己创建的线程需要手动开启才能执行


int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
