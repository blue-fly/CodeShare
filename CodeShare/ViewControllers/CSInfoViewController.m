//
//  CSInfoViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/5.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSInfoViewController.h"
#import "UIButton+BackgroundColor.h"
#import "CSEditNameViewController.h"
#import "UIControl+ActionBlocks.h"
#import "UIImageView+YYWebImage.h"
#import "CSImageViewController.h"
#import "CSQRCodeViewController.h"
#import "CSScanViewController.h"

static NSString *infoCellID = @"infoCellID";

@interface CSInfoViewController () <UITableViewDelegate,UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,weak) UIImageView *headImage;


@end


@interface CSInfoViewController ()

@end

@implementation CSInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    self.view.backgroundColor = WColorBg;
    
    [self initData];
    [self setUpTableView];
    
    //封装3D Touch
    [self setUpThreeDTouch];
    
}

- (void)setUpThreeDTouch {
    
    //在使用3DTouch的api之前，需要先判断是否支持
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 9) {
        
        [self registerForPreviewingWithDelegate:self sourceView:self.headImage];
        
    }
    
}

#pragma mark UIViewControllerPreviewingDelegate

- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    
    //peek 预览功能，可以轻按
    CSImageViewController *imageVC = [[CSImageViewController alloc] init];
    
    return imageVC;
    
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    //pop 重按会调用这个方法，我们在这里可以做任意操作，一般情况下是跳转到预览的控制器
    
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    
}


- (void)initData {
    
    self.dataArr = @[
                     @{
                         @"title": @"昵称",
                         @"class": [CSEditNameViewController class],
                         },
                     @{
                         @"title": @"性别",
                         @"class": [UIViewController class],
                         },
                     @{
                         @"title": @"出生日期",
                         @"class": [UIViewController class],
                         },
                     @{
                         @"title": @"所在地",
                         @"class": [UIViewController class],
                         },
                     @{
                         @"title": @"我的二维码",
                         @"class": [CSQRCodeViewController class],
                         },
                     @{
                         @"title": @"扫一扫",
                         @"class": [CSScanViewController class],
                         }
                     ];
}

- (void)setUpTableView {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(@0);
        
    }];
    
    
    //顶部头像
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    UIImageView *headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"用户头像"]];
    [headerView addSubview:headImage];
    
    self.headImage = headImage;
    
    tableView.tableHeaderView = headerView;
    
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(@0);
        make.width.height.equalTo(@100);
    }];
    [headImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editAvatar)];
    [headImage addGestureRecognizer:tapGesture];
    
    
    //底部退出登录按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    UIButton *logOffButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [logOffButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [logOffButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [logOffButton setBackgroundColor:[UIColor colorWithRed:0.760 green:0.215 blue:0.317 alpha:1.000] forState:UIControlStateNormal];
    
    [logOffButton setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    
    [footerView addSubview:logOffButton];
    
    tableView.tableFooterView = footerView;

    
    [logOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(@0);
        make.height.equalTo(@48);
        make.centerY.equalTo(@0);
    }];
    
    
    [logOffButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
       
        
        [CSUserModel logOff];
        
    }];
    
    
    //注册cell
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:infoCellID];
    
    
    
//    [headImage yy_setImageWithURL: placeholder:<#(nullable UIImage *)#>]
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoCellID];
    
    infoCell.textLabel.font = [UIFont systemFontOfSize:15 weight:-0.15];
    infoCell.textLabel.text = [[self.dataArr objectAtIndex:indexPath.section] objectForKey:@"title"];
    
    infoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return infoCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *cellInfo = [self.dataArr objectAtIndex:indexPath.section];
    
    
    UIViewController *nextVC = [[[cellInfo objectForKey:@"class"] alloc] init];
    
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (void)editAvatar {
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更换头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",@"拍照", nil];
    
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex == 0) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        //从图片库去选择图片
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //设置代理，处理图片选择完成的回调
        imagePicker.delegate = self;
        
        //支持图片裁剪
        imagePicker.allowsEditing = YES;
        
        //将图片选择控制器弹出
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }else if(buttonIndex == 1) {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    //在代理方法中，要先将控制器隐藏
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //将图片信息取出
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //1.将头像设置为这个图片
    [self.headImage setImage:editedImage];
    
    //2.将图片压缩上传
    //无损压缩
//    NSData *imageData = UIImagePNGRepresentation(editedImage);
    
    
    //有损压缩 一般我们去计算得到的图片文件过大，都会用有损压缩
    //压缩质量，0-1之间的数，越小压缩的越厉害
    NSData *imageData = UIImageJPEGRepresentation(editedImage, 0.9);
    
    //上传
    
    NSDictionary *params = @{
                             @"service": @"UserInfo.UpdateAvatar",
                             @"uid": [CSUserModel sharedUser].ID
                             };
    
    [NetworkTool uploadImageData:imageData andParameters:params completeBlock:^(BOOL success, id result) {
        
        
        if (success) {
            //如果这里上传成功了，修改用户model
            [CSUserModel loginWithInfo:result];
        }
        
    }];
    
    
    NSLog(@"%@",info);
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
