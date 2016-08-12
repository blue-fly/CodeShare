//
//  CSScanViewController.m
//  CodeShare
//
//  Created by 段登志 on 16/8/11.
//  Copyright © 2016年 ddz. All rights reserved.
//

#import "CSScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CSScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

//采集设备
@property (nonatomic, strong) AVCaptureDevice *device;
//输入数据(设备的输入)
@property (nonatomic, strong) AVCaptureDeviceInput *input;
//输出的元数据
@property (nonatomic, strong) AVCaptureMetadataOutput *output;


//如果我们想要将输入输出联系起来，需要一个会话
@property (nonatomic, strong) AVCaptureSession *session;

//显示我们摄像头采集到的信息的视图
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CSScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    self.view.backgroundColor = WArcColor;
    
    
    //我们使用扫一扫，会用到摄像头，所以模拟器没有效果
    //我们利用系统提供的方式做扫一扫功能，是将摄像头设备采集的信息当做输入数据，然后通过扫描一个二维码解析的工具，将最终的结果输出，我们需要实现代理方法，去处理结果
    //我们还需要让用户能够看到，所以摄像头采集到的图像还需要展示到界面上
    
    
    //1.先将采集数据的摄像头生成
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //2.生成一个输入数据 ,将我们刚才的设备传入
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    //3.生成一个输出的数据
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    //4.设置代理，将处理完成的结果发送给我们
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //5.生成一个会话，处理输入和输出
    self.session = [[AVCaptureSession alloc] init];
    
    //6.将输入和输出联系起来
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    
    //7.设置处理输入的方式，比如扫描二维码（条形码）
    [self.output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    //将采集到的信息显示到界面上
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    [self.view.layer addSublayer:self.previewLayer];
    
    [self.previewLayer setFrame:self.view.bounds];
    
    //8.将会话开启，开始扫描
    [self.session startRunning];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
//    NSLog(@"%@",metadataObjects);
    
    //将扫描到的结果的第一个元素
    AVMetadataMachineReadableCodeObject *result = [metadataObjects firstObject];
    NSString *resultStr = result.stringValue;
    
    NSLog(@"%@",resultStr);
    
    if (resultStr.length) {
        [self.session stopRunning];
    }
    
    //我们对扫描之后的结果做判断并且处理
    if ([resultStr hasPrefix:@"http"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:resultStr]];
    }
    
    //真正做项目的时候
    
    
    //如果扫描正确，可以将会话关闭
    [self.session stopRunning];
    
    
}
@end
