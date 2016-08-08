//
//  CSSuggestionViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/8.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSSuggestionViewController.h"

@interface CSSuggestionViewController ()

@end

@implementation CSSuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"反馈";
    //对于我们 iOS的app来说，appStore的评分和评论相当重要，不仅关乎到应用的排名，而且对于新用户来说评分很重要，所以我们要尽量将负面的评论引导到自己的反馈平台，如果用户想要提意见，在appStore不是实时的，并且我们可能注意不到
    //我们一般会这样做
    //1.有个反馈的入口，通常在设置界面
    //2.我们需要做一个求好评的弹框
    //如果用户点击给好评，我们就直接跳转到appStore应用界面,让用户打分
    //如果用户点击给差评，我们直接让用户跳转到反馈界面
    //如果选择“以后再说”，那么就可以降低弹出求好评框的频率
    
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
