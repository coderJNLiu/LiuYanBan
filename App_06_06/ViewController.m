//
//  ViewController.m
//  App_06_06
//
//  Created by Augus on 15/9/28.
//  Copyright (c) 2015年 Augus_LWH. All rights reserved.
//

#import "ViewController.h"
#import "UserManager.h"
@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *accountTF;
@property (strong, nonatomic) IBOutlet UITextField *passWordTF;
@property (strong, nonatomic) UserManager * uManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.uManager = [UserManager shareUserManager];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSString * access_token = [userD objectForKey:@"access_token"];
    if (access_token)
    {
        UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"lyVC"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (IBAction)tapLogin:(id)sender
{
    [self.uManager loginUserWithAccount:self.accountTF.text andPassWord:self.passWordTF.text HandleBlock:^(BOOL success) {
        if (success)
        {
            UIViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settingVC"];
            [self presentViewController:vc animated:YES completion:nil];
        }else
        {
            NSLog(@"登录失败！！");
        }
    }];
    
}
- (IBAction)tapRegister:(id)sender
{
    [self.uManager registerUserWithAccount:self.accountTF.text andPassWord:self.passWordTF.text HandleBlock:^(BOOL success) {
        if (success)
        {
            NSLog(@"注册成功！！");
        }else
        {
            NSLog(@"注册失败！！");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
