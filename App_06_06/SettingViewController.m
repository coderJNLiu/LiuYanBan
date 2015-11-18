//
//  SettingViewController.m
//  App_06_06
//
//  Created by Augus on 15/9/28.
//  Copyright (c) 2015年 Augus_LWH. All rights reserved.
//

#import "SettingViewController.h"
#import "UserManager.h"
@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) UserManager * uManager;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.uManager = [UserManager shareUserManager];
}
- (IBAction)tapSave:(id)sender
{
    __weak __block SettingViewController * copy_self = self;
    [self.uManager setUserInfoWithName:self.userName.text andImage:nil HandleBlock:^(BOOL success) {
        if (success)
        {
            UIViewController * vc = [copy_self.storyboard instantiateViewControllerWithIdentifier:@"lyVC"];
            [copy_self presentViewController:vc animated:YES completion:nil];
        }
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
