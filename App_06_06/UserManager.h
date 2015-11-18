//
//  UserManager.h
//  App_06_06
//
//  Created by Augus on 15/9/28.
//  Copyright (c) 2015年 Augus_LWH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void(^UMS)(BOOL success);

@interface UserManager : NSObject
//单例初始化方法
+ (instancetype) shareUserManager;

//注册用户
- (void)registerUserWithAccount:(NSString *)account andPassWord:(NSString *)pw HandleBlock:(UMS)block;

//登录用户
- (void)loginUserWithAccount:(NSString *)account andPassWord:(NSString *)pw HandleBlock:(UMS)block;

//设置用户资料
- (void)setUserInfoWithName:(NSString *)name andImage:(UIImage *)image HandleBlock:(UMS)block;

//保存方法
- (void)save;


@end
