//
//  CSRegisterViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/3.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSRegisterViewController.h"

#import <Masonry.h>
#import "UIButton+BackgroundColor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIControl+ActionBlocks.h"
#import <SMS_SDK/SMSSDK.h>

@interface CSRegisterViewController ()

@end

@implementation CSRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    self.view.backgroundColor = [UIColor colorWithWhite:0.857 alpha:1.000];
    
    [self setUpViews];
    
}

- (void)setUpViews {
    
    
    UITextField *phoneText = [[UITextField alloc] init];
    [self.view addSubview:phoneText];
    [phoneText setBackgroundColor:[UIColor whiteColor]];
    
    UITextField *password = [[UITextField alloc] init];
    [self.view addSubview:password];
    [password setBackgroundColor:[UIColor whiteColor]];
    
    
    UITextField *yanZheng = [[UITextField alloc] init];
    [self.view addSubview:yanZheng];
    [yanZheng setBackgroundColor:[UIColor whiteColor]];
    
    phoneText.placeholder = @"请输入手机号码";
    password.placeholder = @"输入密码";
    yanZheng.placeholder = @"输入验证码";
    password.secureTextEntry = YES;
    
    
    
    //对输入框进行布局
    [phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(@0);
        make.top.equalTo(@64);
        make.height.equalTo(@64);
        
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(phoneText.mas_bottom);
        make.height.equalTo(@64);
        
    }];
    
    [yanZheng mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(@0);
        make.top.equalTo(password.mas_bottom).offset(16);
        make.height.equalTo(@64);
    }];
    
    UIImageView *phoneLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户图标"]];
    UIImageView *passLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码图标"]];
    UIImageView *yanLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验证信息图标"]];
    
    UIView *phoneLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    UIView *passLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    UIView *yanLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    
    [phoneLeft addSubview:phoneLeftImage];
    [passLeft addSubview:passLeftImage];
    [yanLeft addSubview:yanLeftImage];
    
    //设置左边图标布局
    [phoneLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        //让视图居中
        make.center.equalTo(@0);
        
    }];
    
    [passLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(@0);
    }];
    
    [yanLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        
    }];
    
    phoneText.leftView = phoneLeft;
    password.leftView = passLeft;
    yanZheng.leftView = yanLeft;
    
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    password.leftViewMode = UITextFieldViewModeAlways;
    yanZheng.leftViewMode = UITextFieldViewModeAlways;
    
    
    
    phoneText.font = [UIFont systemFontOfSize:15 weight:-0.15];
    password.font = [UIFont systemFontOfSize:15 weight:-0.15];
    yanZheng.font = [UIFont systemFontOfSize:15 weight:-0.15];
    
    
    phoneText.layer.borderColor = [UIColor grayColor].CGColor;
    phoneText.layer.borderWidth = 0.5;
    password.layer.borderColor = [UIColor grayColor].CGColor;
    password.layer.borderWidth = 0.5;
    yanZheng.layer.borderColor = [UIColor grayColor].CGColor;
    yanZheng.layer.borderWidth = 0.5;
    
    
    
    //获取验证码按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [rightButton titleLabel].font = [UIFont systemFontOfSize:14 weight:-0.15];
    [rightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [rightButton layer].borderColor = [UIColor lightGrayColor].CGColor;
    [rightButton layer].borderWidth = 1.0f;
    [rightButton layer].cornerRadius = 4.f;
    [rightButton layer].masksToBounds = YES;
    
    
    [rightButton setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [rightButton setBackgroundColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 108, 48)];
    [rightView addSubview:rightButton];
    
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.top.equalTo(@8);
        make.left.equalTo(@4);
        
    }];
    
    yanZheng.rightView = rightView;
    yanZheng.rightViewMode = UITextFieldViewModeAlways;
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton titleLabel].font = [UIFont systemFontOfSize:15];
    
    [loginButton setFrame:CGRectMake(0, 320, self.view.frame.size.width, 64)];
    
    [self.view addSubview:loginButton];
    

    [loginButton setBackgroundColor:[UIColor colorWithRed:0.214 green:0.538 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor greenColor] forState:UIControlStateDisabled];
    [loginButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];

    //设置用户输入框，只能输入数字
    phoneText.keyboardType = UIKeyboardTypeNumberPad;
    
    
    //ReactiveCocoa 处理
    //ReactiveCocoa 可以代替 delegate\target action\通知\kvo\...一系列iOS开发里面的数据传递方式
    //RAC 使用的是信号流的方式来处理我们的数据，无论是按钮点击事件还是输入框事件还是网络数据获取...都可以被当做"信号"
    //我们可以观测某个信号的改变，来做相应的操作
    //RAC 还可以将做个信号合并处理，过滤某些信号，自定义一些信号，所以比较强大
    
    
    //RAC 帮我们实现了很多系统自带的信号，文本框的变化，按钮点击
    //我们去订阅这些信号，那么当信号一旦发生变化，就会通知我们
   
    [phoneText handleControlEvents:UIControlEventEditingChanged withBlock:^(UITextField *phoneText) {
        NSString *phone = phoneText.text;
        if (phone.length >= 11) {
            //当输入的手机号超过11位，直接将密码框设置为第一响应者
            [password becomeFirstResponder];
            if (phone.length > 11) {
                phoneText.text = [phone substringToIndex:11];
            }
            
        }
        
    }];
    
    // 获取验证码按钮默认是不可点的
    rightButton.enabled = NO;
    //我们可以直接将某个信号处理的返回结果，设置为某个对象的属性值。
//    [RACSignal combineLatest:<#(id<NSFastEnumeration>)#> reduce:<#^id(void)reduceBlock#>]
    //combineLatest 一堆信号的集合
    
    RAC(rightButton,enabled) = [RACSignal combineLatest:@[phoneText.rac_textSignal] reduce:^(NSString *phone){
       
        return @(phone.length >= 11);
        
    }];
    
    
    //RAC 可以将信号和处理写到一起，我们写项目的时候不用再去来回找了
    loginButton.enabled = NO;
    RAC(loginButton,enabled) = [RACSignal combineLatest:@[phoneText.rac_textSignal, password.rac_textSignal, yanZheng.rac_textSignal] reduce:^(NSString *phone,NSString *password,NSString *yanZheng){
        
        return @(phone.length >= 11 && password.length >= 6 && yanZheng.length == 4);
    }];
    
    
    [rightButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        //发送验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            
            if (error) {
                
            }else {
                NSLog(@"获取验证码成功");
                
            }
            
            
        }];
    }];
    
    
}
//我的需求
//1.账户输入框用户只可以输入数字
//2.当用户输入完11个数字，不能再继续输入
//3.当账号输入框，少于11个数字，那么获取验证码按钮，灰色不可点
//4.当账号为11个数字，密码大于等于6个长度，验证码为4个数字，注册按钮可用
//怎么做？
//1.设置键盘样式
//2.可以在代理方法里判断，如果输入框长度大于11返回NO
//3.可以在代理方法里面处理
//4.也可以在代理方法中处理，但是非常麻烦



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
