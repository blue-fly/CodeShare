//
//  CSQRCodeViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/11.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSQRCodeViewController.h"
#import "UIImage+Resize.h"

#import "UIImage+Blur.h"
#import "UIView+Screenshot.h"

#import <OpenShareHeader.h>

#import "QREncoder.h"

@interface CSQRCodeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *dataArr;

@end

//二维码生成
//iOS7 以前，我们做生成二维码功能，都是用的第三方框架 ZXing 或者 ZBar
//但是这两个库，效率不高，而且对64位支持不好，所以现在我们基本不用了
//现在可以用iOS自带的二维码扫描和生成

//分享图片或者文字到第三方应用
//自定义分享界面/openShare
//OpenShare 体积非常小 如果用这个来做第三方分享或者支付，登录，会大大减小我们的app的体积
//OpenShare 将常见的第三方平台统一了api，统一了分享的方法，我们使用的时候，只需要按照一个步骤来
//OpenShare 使用非常简单


//iOS9 之后，如果我们的应用想要打开其他的应用做分享，首先要在plist文件中加入theme


//OpenShare的一些缺点：在做第三方登录或者分享的时候，如果手机上没有安装，不能跳转到web登录界面
@implementation CSQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"二维码生成";
    self.view.backgroundColor = WArcColor;
    
    self.dataArr = @[
                     @{
                         @"title": @"分享到QQ好友",
                         @"icon": @"",
                         },
                     @{
                         @"title": @"分享到QQ空间",
                         @"icon": @"",
                         },
                     @{
                         @"title": @"分享到朋友圈",
                         @"icon": @"",
                         },
                     @{
                         @"title": @"分享到微信好友",
                         @"icon": @"",
                         },
                     @{
                         @"title": @"分享到微博",
                         @"icon": @"",
                         },
                     
                     ];
    
    
    self.imageView = [[UIImageView alloc] init];
    [self.view addSubview:self.imageView];
    
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.height.equalTo(@200);
        
    }];
    
    
    //封装一个方法，生成一张二维码
//    [self createQRCode];
    [self createQRCodeImage];
    
    
    //给我们生成的二维码添加一个logo
    [self addLogoOnQRCode];
    
    
    
    //自定义分享按钮
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(@0);
        make.centerX.equalTo(@0);
        make.height.equalTo(@48);
        make.top.equalTo(self.imageView.mas_bottom).offset(48);
        
    }];
    
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setBackgroundColor:WArcColor];
    [shareButton addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)showShareView {
    
    //设置背景蒙版
    UIView *backView = [[UIView alloc] init];
    //将当前控制器的view 截图并且做模糊处理
    UIImage *backImage = [[self.view screenshot] darkImage];
    
    [backView layer].contents = (id)(backImage.CGImage);
    
    [self.view addSubview:backView];
    
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(@0);
        
    }];
    
    //弹出自定义分享视图
    UITableView *shareView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    shareView.delegate = self;
    shareView.dataSource = self;
    
    [backView addSubview:shareView];
    
    [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(@0);
        make.height.equalTo(@280);
        make.top.equalTo(backView.mas_bottom);
        
    }];
    
    //如何用Masonry的约束做一个动画
    [shareView mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(backView.mas_bottom).offset(-280);
        
    }];
    
    [shareView setNeedsUpdateConstraints];
//    [UIView animateWithDuration:0.35 animations:^{
//        [shareView layoutIfNeeded];
//    }];
    
    
    //注册cell
    [shareView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
 
    
    //去掉tableView下面的小横条
    [shareView setTableFooterView:[UIView new]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //取出cell的信息，配置
    cell.textLabel.font = [UIFont systemFontOfSize:15 weight:-0.15];
    cell.textLabel.text = [self.dataArr[indexPath.row] objectForKey:@"title"];
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    
    
    OSMessage *message = [[OSMessage alloc] init];
    
    
    message.title = @"二维码";
    message.desc = @"我自己生成的二维码";
    message.image = UIImageJPEGRepresentation(self.imageView.image, 0.9);
    
    
    //这里可以判断点击的是哪一个cell
    if (indexPath.row == 0) {
        [OpenShare shareToQQZone:message Success:^(OSMessage *message) {
            
            NSLog(@"分享成功 %@",message);
            
        } Fail:^(OSMessage *message, NSError *error) {
            
            NSLog(@"分享失败");
        }];
    }
    
//    @property NSString* title;
//    @property NSString* desc;
//    @property NSString* link;
//    @property NSData* image;
    
    
}



- (void)createQRCode {
    
    //1.设置要生成的字符串
    NSString *originString = @"www.baidu.com";
    
    //2.CIFilter 设置过滤器(滤镜),一般 滤镜需要我们自己配置，比如美颜，一些常用的，系统提供，我们可以直接用
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //3.将过滤器设置默认参数
    [filter setDefaults];
    //4.通过过滤器添加数据
    NSData *qrData = [originString dataUsingEncoding:NSUTF8StringEncoding];
    
    //5.通过kvc 设置过滤器的属性
    [filter setValue:qrData forKey:@"inputMessage"];
    //6.获取二维码图片
    UIImage *qrImage = [UIImage imageWithCIImage:[filter outputImage]];
    
    //将生成的比较模糊的二维码按照图片上面的像素扩展一下
//    UIImage *image = [qrImage resizedImage:CGSizeMake(200, 200) interpolationQuality:kCGInterpolationDefault];
    
    //我们这样生成和展示二维码，是效率最高的,但是二维码比较模糊
    [self.imageView setImage:qrImage];
    
    
}


- (void)addLogoOnQRCode {
    
    //可以在 imageView上再加一个imageView
    //或者直接在imageView上加一个layer
    CALayer *layer = [CALayer layer];
    
//    [self.imageView.layer addSublayer:layer];
    
    [self.imageView.layer insertSublayer:layer atIndex:0];
    
    //设置layer 的一些属性
    
    layer.frame = CGRectMake(75, 75, 50, 50);
//    layer.contents = (id)[[UIImage imageNamed:@"icon"] CGImage];
    layer.backgroundColor = [UIColor redColor].CGColor;
        
    
}

- (void)createQRCodeImage {
    
    //1.先定义一个字符串
    NSString *qrStr = @"https://www.baidu.com";
    //2.生成一个数据矩阵
    DataMatrix *data = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:qrStr];
    
    //3.生成一张图片
    self.imageView.image = [QREncoder renderDataMatrix:data imageDimension:200];
    
}



@end
