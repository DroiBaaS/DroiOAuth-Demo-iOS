//
//  UserInfoViewController.m
//  DroiAccountDemo
//
//  Created by Jon on 16/6/16.
//  Copyright © 2016年 Droi. All rights reserved.
//

#import "UserInfoViewController.h"
#import <DroiOAuth/DroiOAuth.h>
#import <DroiCoreSDK/DroiCoreSDK.h>
@interface UserInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userInfo;


@property (weak, nonatomic) IBOutlet UISwitch *phoneNumberSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *emailSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *userInfoSwitch;

@property (copy, nonatomic)NSString *token;

@property (copy, nonatomic)NSString *openid;


@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SegChange:(UISegmentedControl *)sender {
    
    NSInteger selectedSegmentIndex = sender.selectedSegmentIndex;
    if(selectedSegmentIndex == 0){
        [DroiOAuth setLanguage:DroiOAuthLanguageZH];
    }
    else{
        [DroiOAuth setLanguage:DroiOAuthLanguageEN];
    }
    
}
- (IBAction)getUserInfo:(id)sender {
    
    [DroiOAuth getUserInfoWithToken:self.token openId:self.openid Scope:[self getScope] Callback:^(id object, NSError *error) {
        
        if (error == nil) {
            NSLog(@"userInfo:%@",object);
            self.userInfo.text = [object description];
        }
        
    }];
}
- (IBAction)checkToken:(id)sender {
    
    [DroiOAuth checkTokenExpire:self.token Callback:^(id object, NSError *error) {
        if (error == nil) {
            
            NSLog(@"Check Token:%@",object);
            self.userInfo.text = [object description];
        }
    }];

}

- (IBAction)login:(id)sender {
    
    [DroiOAuth requestTokenWithViewController:self Callback:^(id object, NSError *error) {
        if (error == nil) {
            NSLog(@"Token data:%@",object);
            //这里可以将token 和 openid 保存起来 下次直接使用token 和 openid 登录
            NSString *token = [object objectForKey:@"token"];
            NSString *openid = [object objectForKey:@"openid"];
            self.token = token;
            self.openid = openid;
            self.userInfo.text = [object description];
        }
    }];
}

- (DroiOAuthScope )getScope{
    DroiOAuthScope scope;
    if (self.userInfoSwitch.on) {
        scope = scope|DroiOAuthScopeUserInfo;
    }
    if (self.phoneNumberSwitch.on) {
        scope = scope|DroiOAuthScopeUserPhoneNumber;
    }
    if (self.emailSwitch.on) {
        scope = scope|DroiOAuthScopeUserEmail;
    }
    return scope;
}


@end
