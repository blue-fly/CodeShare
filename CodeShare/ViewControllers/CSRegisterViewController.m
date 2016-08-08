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

#import "NSTimer+Blocks.h"
#import "NSTimer+Addition.h"
#import "NSString+MD5.h"
#import "UIAlertView+Block.h"

@interface CSRegisterViewController ()

//写成属性，可以方便监控变化
@property (nonatomic,strong) NSNumber* waitTime;

//定时器作为属性
@property (nonatomic,strong) NSTimer *timer;
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
    
    
    //ReactiveCocoa 处理，
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
    
     //我们给等待时间赋初值为-1
     self.waitTime = @-1;
    
    
    // 获取验证码按钮默认是不可点的
    rightButton.enabled = NO;
    //我们可以直接将某个信号处理的返回结果，设置为某个对象的属性值。
//    [RACSignal combineLatest:<#(id<NSFastEnumeration>)#> reduce:<#^id(void)reduceBlock#>]
    //combineLatest 一堆信号的集合
    
    RAC(rightButton,enabled) = [RACSignal combineLatest:@[phoneText.rac_textSignal, RACObserve(self, waitTime)] reduce:^(NSString *phone, NSNumber *waitTime){
       
        return @(phone.length >= 11 && waitTime.integerValue <= 0);
        
    }];
    
    
    //RAC 可以将信号和处理写到一起，我们写项目的时候不用再去来回找了
    loginButton.enabled = NO;
    RAC(loginButton,enabled) = [RACSignal combineLatest:@[phoneText.rac_textSignal, password.rac_textSignal, yanZheng.rac_textSignal] reduce:^(NSString *phone,NSString *password,NSString *yanZheng){
        
        return @(phone.length >= 11 && password.length >= 6 && yanZheng.length == 4);
    }];
    
    
    //如果在实际开发环境中，我们在做发送验证码的功能时，都会有一个等待时间
    //1.为了节省成本
    //一般开发中，用第三方短信提供商做发送验证码功能，一条/6-8分钱。所有成本还是挺高的
    //2.为了用户体验
    [rightButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        
        rightButton.enabled = NO;
        
        self.waitTime = @60;
        
        //发送验证码
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneText.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            
            if (error) {
                
                //如果失败，让等待时间变为-1
                self.waitTime = @-1;
                
            }else {
                NSLog(@"获取验证码成功");
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^{
                    
                        
                        //让等待时间减一
                        self.waitTime = [NSNumber numberWithInteger:self.waitTime.integerValue-1];
                    
                    
                } repeats:YES];
                
                
            }
            
            
        }];
    }];
    
    
    //用RAC监控数据的变化，显示相应的界面
    [RACObserve(self, waitTime) subscribeNext:^(NSNumber *waitTime) {
        
        
        if (waitTime.integerValue <= 0) {
            //将定时器去除的操作写到这里
            [self.timer invalidate];
            self.timer = nil;
            
            [rightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        }else if(waitTime.integerValue > 0){
            [rightButton setTitle:[NSString stringWithFormat:@"等待%@秒",waitTime] forState:UIControlStateNormal];
        }
        
    }];
    
    
    [[loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        //一般我们的密码不可能会明文传输，最简单的也要进行MD5加密
        //一旦进行MD5 加密，会破坏字符串原来携带的信息
        //但是对于密码来说，服务器和app交互并不需要密码所携带的信息，所以无论是登录还是注册，我们都必须加密（服务器也不知道你的密码是多少）
        
        //MD5 加密算法是死的，所以别人可以通过暴力破解的方式来获取你的密码
        
        //所以我们有时候，会将我们密码加盐后再进行加密，传给服务器
        //固定字符串的盐
        //随机字符串的盐
        NSString *pass = [password.text md532BitUpper];
        
        NSDictionary *params = @{
                                 @"service": @"User.Register",
                                 @"phone": phoneText.text,
                                 @"password": pass,
                                 @"verificationCode": yanZheng.text
                                 };
        
        [NetworkTool getDataWithParameters:params completeBlock:^(BOOL success, id result) {
            
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [UIAlertView alertWithCallBackBlock:nil title:@"温馨提示" message:result cancelButtonName:@"确定" otherButtonTitles:nil];
                
            }
            
            
        }];
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //取消编辑
    [self.view endEditing:YES];
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


//需求
//1.点击发送验证码，按钮变为不可用，发送验证码
//2.如果发送成功，按钮不可用，按钮上面显示60秒倒计时
//3.如果失败，将按钮设置为可用，提示发送失败
//4.当倒计时结束的时候，将按钮设置为可用（还要考虑到手机号是否符合规则）
//我们可以设置一个初始数字为60的变量，发送验证码的按钮可用与否再添加一个条件，当0-60的时候按钮不可用，我们的定时器没走一次，将这个数字减去1，同时监控这个数字的变化，去改变我们的按钮倒计时提示


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
