//
//  ViewController.m
//  LAContextTest
//
//  Created by ZHS on 2017/1/18.
//  Copyright © 2017年 ZHS. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        //        [self inputUserinfo];
        return;
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = self.view.center;
    btn.bounds = CGRectMake(0, 0, 100, 100);
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self inputUserinfo];
}

- (void)buttonClick {
    [self inputUserinfo];
}

///  输入用户信息
- (void)inputUserinfo
{
    LAContext *ctx = [[LAContext alloc] init];
    if ([ctx canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:NULL]) {
        NSLog(@"指纹识别！！");
        // // 输入指纹，异步// 提示：指纹识别只是判断当前用户是否是手机的主人！程序原本的逻辑不会受到任何的干扰！
        [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过Home键验证已有手机指纹" reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"验证成功");
            }
            else if (error.code == LAErrorUserFallback) {
                // 用户指纹无法识别，之后用户点击输入密码，走的是 LAErrorUserFallback，指纹无法识别
                NSLog(@"指纹无法识别");
            }
            else if (error.code == LAErrorUserCancel) {
                NSLog(@"用户点击了”取消”按钮");
            }
            else if (error.code == LAErrorUserFallback) {
                NSLog(@"用户取消，点击了”输入密码”按钮");
            }
            else if (error.code == LAErrorSystemCancel) {
                NSLog(@"系统取消，例如激活了其他应用程序");
            }
            else if (error.code == LAErrorPasscodeNotSet) {
                NSLog(@"验证无法启动，因为设备上没有设置密码");
            }
            else if (error.code == LAErrorTouchIDNotAvailable) {
                NSLog(@"验证无法启动，因为设备上没有 Touch ID");
            }
            else if (error.code == LAErrorTouchIDNotEnrolled) {
                NSLog(@"验证无法启动，因为没有输入指纹");
            }
        }];
        NSLog(@"开始判断指纹！！！");
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有开启Touch ID设备" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
