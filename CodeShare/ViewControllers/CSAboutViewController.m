//
//  CSAboutViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/8.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSAboutViewController.h"
#import <MessageUI/MessageUI.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface CSAboutViewController () <MFMessageComposeViewControllerDelegate> {
    CTCallCenter *ctCallCenter;
}

@end

@implementation CSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //这个界面一般都是写死的，我们用xib做最好
    //会包含 app 的基本信息（版本，开发），和联系方式
    //打电话和发短信功能
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    

    [self setUpButtons];
    
    //我们如何去监控手机打电话的状态，去做相应的处理
    ctCallCenter = [[CTCallCenter alloc] init];
    [ctCallCenter setCallEventHandler:^(CTCall *call) {
        NSLog(@"%@", call.callState);
        //在这里根据不同的状态做对应的处理
        //如果在这里，有涉及到视图的修改，要主动跳转到主线程去做
        dispatch_async(dispatch_get_main_queue(), ^{
            self.view.backgroundColor = WArcColor;
        });
        
    }];
    
    //我们现在用的arc，如果对象不被引用会直接销毁掉，所以虽然我们写好了处理的block，但是callCenter是被释放了，应当callCenter当成成员变量
    
}

- (void)setUpButtons {
    
    NSArray *titles = @[@"打电话一",@"打电话二",@"发短信一",@"发短信二"];
    
    UIButton *lastButton = nil;
    
    
    for (int i = 0; i < titles.count; ++i) {
        //取出title，创建一个button
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
       
        
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setBackgroundColor:WArcColor];
        
        [self.view addSubview:button];
        
        //我们用masonry设置这样的约束
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@16);
            make.centerX.equalTo(@0);
            make.height.equalTo(@48);
            make.top.equalTo(lastButton? lastButton.mas_bottom : @0).offset(lastButton? 16 : 80);
            
        }];
        
        lastButton = button;
        button.tag = i + 10;
        
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}



- (void)tapButton:(UIButton *)sender {
    
    if(sender.tag == 10) {
        
        //最简单的打电话方式 调用电话 app，直接打给某个号码，并且没有提示
        //打给110
        //没有提示可能会造成 appstore 拒绝我们的应用
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://110"]];
    }else if (sender.tag == 12) {
        
        //用这种方式发短信，无法回到我们的应用
        //无法指定信息内容
        //无法群发
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://120"]];
        
    }else if (sender.tag == 11) {
        
        //我们甚至可以用webView来打电话
        //这种方式，打完电话可以直接回到我们的应用
        //在拨出去之前，会给用户一个提示
        
        UIWebView *webView = [[UIWebView alloc] init];
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://119"]]];
        //最后记得将webView加到self.view上
        [self.view addSubview:webView];
        //这里的webView最好用懒加载写
        
    }else if (sender.tag == 13) {
        
        
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
        //用这种方式发短信，可以自定内容
        //如果应用的用户有 iPad或 iPod，这个适配一定要做
        if([MFMessageComposeViewController canSendText]) {
            messageVC.body = @"青岛啤酒节开幕了";
            messageVC.recipients = @[@"110",@"120",@"119",@"911"];
            
            //设置代理
            messageVC.messageComposeDelegate = self;
            
            [self presentViewController:messageVC animated:YES completion:nil];
        }
        
        
    }
    
    //一般 iOS app 直接应用传值都是使用这种方式，一个app 一旦定义了自己的scheme，那么其他的app就可以直接打开它，我们在appDelegate中可以根据传来的不同参数执行不同的功能
    //在iOS9以后，我们想要打开其他app，需要经过用户同意才可以，并且需要先在plist文件中配置好对方app的scheme
    //我们还可以通过这种方式去搜集用户手机上都安装了哪些app
    
    [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tencent://"]];
    
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    //不管是成功还是失败，我们先要将控制器隐藏
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"%d",result);
    
    //经过实践之后发现，群发的人数不要超过50人，否则会卡到条状的时候
    
}


@end
