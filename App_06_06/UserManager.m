//
//  UserManager.m
//  App_06_06
//
//  Created by Augus on 15/9/28.
//  Copyright (c) 2015年 Augus_LWH. All rights reserved.
//

#import "UserManager.h"
#import "AFNetworking.h"
#import "Configs.h"
@interface UserManager ()
@property (strong, nonatomic) AFHTTPRequestOperationManager * afManager;
@property (strong, nonatomic) NSString * token;
@property (strong, nonatomic) NSString * account;
@property (strong,nonatomic)  NSString * userName;
@property (strong, nonatomic) UIImage * headImage;
@end

@implementation UserManager

+ (instancetype)shareUserManager
{
    static UserManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc]init];
        
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.afManager = [[AFHTTPRequestOperationManager alloc]init];
        //关闭自动解析
        self.afManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}

//注册方法实现
- (void)registerUserWithAccount:(NSString *)account andPassWord:(NSString *)pw HandleBlock:(UMS)block
{
    NSDictionary * dic = @{@"account":account,@"password":pw};
    [self.afManager POST:zhuceURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic1 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString * success = dic1[@"success"];
        if ([success isEqualToString:@"0"])
        {
            NSLog(@"注册成功");
            block(YES);
        }else
        {
            block(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Register Request Error = %@",error.localizedDescription);
        block(NO);
    }];
}

//登录实现
- (void)loginUserWithAccount:(NSString *)account andPassWord:(NSString *)pw HandleBlock:(UMS)block
{
    NSDictionary * dic = @{@"account":account,@"password":pw};
    __weak __block UserManager * copy_self = self;
    [self.afManager POST:dengluURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSString * success = dic2[@"success"];
        if ([success isEqualToString:@"0"])
        {
            copy_self.token = dic2[@"access_token"];
            copy_self.account = account;
            [copy_self save];
            block(YES);
        }else
        {
            NSLog(@"登录失败");
            block(NO);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Login Error = %@",error.localizedDescription);
        block(NO);
    }];
}

//设置信息
- (void)setUserInfoWithName:(NSString *)name andImage:(UIImage *)image HandleBlock:(UMS)block
{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    NSDictionary * dic = @{@"access_token":[userD objectForKey:@"access_token"],@"name":name};
    __weak __block UserManager * copy_self = self;
    [self.afManager POST:setUserInfoURL parameters:dic constructingBodyWithBlock:^void(id<AFMultipartFormData> formData) {
        if (image)
        {
            NSData * d = UIImagePNGRepresentation(image);
            [formData appendPartWithFileData:d name:@"image" fileName:@"123.png" mimeType:@"image/png"];
        }
    } success:^void(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSString * success = dic[@"success"];
        if ([success isEqualToString:@"0"])
        {
            self.userName = name;
            self.headImage = image;
            [copy_self save];
            block(YES);
        }
        else
        {
            block(NO);
        }
    } failure:^void(AFHTTPRequestOperation * op, NSError * error) {
        block(NO);
    }];
    

}

- (void)save
{
    NSUserDefaults * userD = [NSUserDefaults standardUserDefaults];
    [userD setObject:self.token forKey:@"access_token"];
    [userD setObject:self.account forKey:@"account"];
    [userD setObject:self.userName forKey:@"userName"];
    [userD setObject:UIImagePNGRepresentation(self.headImage) forKey:@"userImage"];
    //同步数据
    [userD synchronize];
    
}



@end
