//
//  LoginViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/17/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "LoginViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseManager.h"
#import "TabbarViewController.h"

@interface LoginViewController () <FirebaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    NSString *useremail = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    [FirebaseManager sharedInstance].delegate = self;
    [[FirebaseManager sharedInstance] loginUserEmail:useremail password:password];
    
}

-(void)userDidLoginWithUid:(NSString *)uid {
    [self performSegueWithIdentifier:@"loggedin" sender:uid];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"loggedin"]) {
        TabbarViewController *dvc = segue.destinationViewController;
        dvc.authData = sender;
    }
}


@end
