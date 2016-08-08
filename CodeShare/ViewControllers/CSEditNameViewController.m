//
//  CSEditNameViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/5.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSEditNameViewController.h"

#import "UIControl+ActionBlocks.h"

@interface CSEditNameViewController ()

@end

@implementation CSEditNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"更改姓名";
    self.view.backgroundColor = WArcColor;
 
    
    
    UITextField *nickName = [[UITextField alloc] init];
    [self.view addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(@0);
        make.top.equalTo(@80);
        make.height.equalTo(@48);
        
    }];
    
    nickName.backgroundColor = [UIColor whiteColor];
    nickName.placeholder = @"不得超过十五个字母和字符";
    nickName.returnKeyType = UIReturnKeyDone;
    
    [nickName handleControlEvents:UIControlEventEditingDidEndOnExit withBlock:^(id weakSender) {
       //在这里调用修改用户信息的接口
        NSDictionary *params = @{
                                 @"service": @"UserInfo.UpdateInfo",
                                 @"uid": [CSUserModel sharedUser].ID,
                                 @"nickname": nickName.text,
                                 };
        
        [NetworkTool getDataWithParameters:params completeBlock:^(BOOL success, id result) {
           
            if (success) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
                
                
            }
            
        }];
    }];
    
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
