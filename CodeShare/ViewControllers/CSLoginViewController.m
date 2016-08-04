//
//  CSLoginViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/3.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSLoginViewController.h"

#import <Masonry/Masonry.h>
//这里封装了一个方法，可以通过一个颜色，生成一张图片
#import "UIImage+Color.h"
#import "UIButton+BackgroundColor.h"
#import "UIControl+ActionBlocks.h"


#import "CSForgetViewController.h"
#import "CSRegisterViewController.h"

#import "UIAlertView+Block.h"
#import "NSString+MD5.h"

#import "CSUserModel.h"

@interface CSLoginViewController ()

@end

@implementation CSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.873 green:0.830 blue:0.914 alpha:1.000];
    self.title = @"登录";
    
    
    //一般创建ui都会写到viewDidLoad
    //viewDidLoad 是控制器的视图已经加载完毕时候会自动调用的一个方法
    [self setUpViews];
    
}

//界面将要出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//界面已经出现
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

//界面将要消失
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

//界面已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)setUpViews {
    
    //创建手机号码输入框，密码输入框，登录按钮
    UITextField *phonetext = [[UITextField alloc] init];
    [self.view addSubview:phonetext];
    [phonetext setBackgroundColor:[UIColor whiteColor]];
    
    UITextField *password = [[UITextField alloc] init];
    [self.view addSubview:password];
    [password setBackgroundColor:[UIColor whiteColor]];
    
    phonetext.placeholder = @"输入邮箱或者手机号码";
    password.placeholder = @"输入密码";
    password.secureTextEntry = YES;
    
    
    UIImageView *phoneLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户图标"]];
    
    UIImageView *passLeftImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"密码图标"]];
    
    UIView *phoneLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    
    UIView *passLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    [phoneLeft addSubview:phoneLeftImage];
    [passLeft addSubview:passLeftImage];
    
    //在使用Masonry时，需要addSubview让其拥有父视图
    
    [phoneLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
       //让视图居中
        make.center.equalTo(@0);
        
    }];
    
    [passLeftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
    
    
    
    phonetext.leftView = phoneLeft;
    password.leftView = passLeft;
    phonetext.leftViewMode = UITextFieldViewModeAlways;
    password.leftViewMode = UITextFieldViewModeAlways;
    
    
    //手写输入框的布局
    //在写布局的时候，我们添加的所有约束必须能够唯一确定这个视图的位置和大小
    [phonetext mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.right.equalTo(@0);
        make.left.right.equalTo(@0);
        make.height.equalTo(@64);
        make.top.equalTo(@120);
        //因为Masonry 在实现的时候，充分考虑到我们写约束的时候越简单越好，所有引入了链式写法，所以我们在写的时候，可以尽量的将一样的约束写到一起
    }];
    
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.equalTo(@0);
        make.height.equalTo(@64);
        make.top.equalTo(phonetext.mas_bottom);
        
    }];
    
    phonetext.font = [UIFont systemFontOfSize:15 weight:-0.15];
    password.font = [UIFont systemFontOfSize:15 weight:-0.15];
    
    
    phonetext.layer.borderColor = [UIColor grayColor].CGColor;
    phonetext.layer.borderWidth = 0.5;
    password.layer.borderColor = [UIColor grayColor].CGColor;
    password.layer.borderWidth = 0.5;
    
    //写自定义的button 一定要用工厂方法
    UIButton *forgetPass = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPass setTitle:@"忘记密码" forState:UIControlStateNormal];
    
    [forgetPass titleLabel].font = [UIFont systemFontOfSize:14];
    
    //80 64
    //我们用 autoLayout 时候，就不能再以某个视图的 frame 当做参数来用（此时，视图的frame是不可靠的）
    [forgetPass setFrame:CGRectMake(self.view.frame.size.width - 80, 250, 80, 64)];
    
    [self.view addSubview:forgetPass];
    
    //登录按钮
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton titleLabel].font = [UIFont systemFontOfSize:15];
    
    [loginButton setFrame:CGRectMake(0, 320, self.view.frame.size.width, 64)];
    
    [self.view addSubview:loginButton];
    
    //设置按钮不同状态先得背景颜色
    //一般我们的按钮，都会需要三个状态下的背景颜色，1，普通状态，2.高亮状态 3.不可用状态
    //1.不同的状态设置不同的图片
    //2.在不同状态的事件下面，设置按钮的背景颜色
    //我们需要实现很多方法，麻烦
    //3.使用封装好的分类方法，简单方便
    [loginButton setBackgroundColor:[UIColor colorWithRed:0.214 green:0.538 blue:0.000 alpha:1.000] forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor greenColor] forState:UIControlStateDisabled];
    [loginButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    //当我们不用autolayout的时候，如何去让视图自适应
    //autoResizing是 autoLayout之前界面自适应的工具，只有几个枚举类型
    //让登陆按钮的宽度和左边距保持跟父控件相对位置不变
    loginButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    
    //两个跳转界面
    [forgetPass setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    //设置按钮的动作，跳转到另外一个控制器
//    [forgetPass addTarget:self action:@selector(gotoForget) forControlEvents:UIControlEventTouchUpInside];
    
    //我们还可以将按钮的事件与按钮写到一块
    
    [forgetPass handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        
        //把按钮的事件回调写到block里，便于我们在写界面的时候，方便的加入控制事件
        
        CSForgetViewController *forgetVC =[[CSForgetViewController alloc] init];
        
        [self.navigationController pushViewController:forgetVC animated:YES];
        
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(gotoRegister)];
    
    
    [phonetext handleControlEvents:UIControlEventEditingChanged withBlock:^(id weakSender) {
       
        if (phonetext.text.length >= 11) {
            [password becomeFirstResponder];
            
            if (phonetext.text.length > 11) {
                phonetext.text = [phonetext.text substringFromIndex:11];
            }
            
        }
    }];
    
    
    RAC(loginButton,enabled) = [RACSignal combineLatest:@[phonetext.rac_textSignal,password.rac_textSignal] reduce:^(NSString *phone,NSString *pass){
        
        return @(phone.length >= 11 &&pass.length >= 6);
        
    }];
    
    
    //登录
    [loginButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
       
        
        NSDictionary *params = @{
                                 @"service": @"User.Login",
                                 @"phone": phonetext.text,
                                 @"password": [password.text md532BitUpper]
                                 };
        
        [NetworkTool getDataWithParameters:params completeBlock:^(BOOL success, id result) {
            
            if (success) {
                NSLog(@"%@",result);
                
                CSUserModel *user = [CSUserModel sharedUser];
//                [user setValuesForKeysWithDictionary:result];
                // YYModel
                [user yy_modelSetWithDictionary:result];
                
                
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }else {
                
                [UIAlertView alertWithCallBackBlock:nil title:@"温馨提示" message:result cancelButtonName:@"确定" otherButtonTitles:nil];
                
            }
            
            
        }];
        
    }];
    
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


- (void)gotoRegister {
    
    CSRegisterViewController *registerVC =[[CSRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
    
}


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
