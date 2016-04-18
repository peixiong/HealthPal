//
//  LoginViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/17/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "LoginViewController.h"
#import <Firebase/Firebase.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onLoginButtonPressed:(UIButton *)sender {
    NSString *useremail = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    [ref authUser:useremail password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            NSLog(@"There was an error: %@", error.localizedDescription);
        } else {
            NSLog(@"We are now logged in with userId = %@", authData.uid);
            NSString *url = [NSString stringWithFormat:@"https://blinding-heat-8730.firebaseio.com/users/%@", authData.uid];
            Firebase *readRef = [[Firebase alloc] initWithUrl:url];
            
            [readRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                NSLog(@"%@", snapshot.value);
                NSLog(@"username = [%@]", snapshot.value[@"username"]);
                NSData *imageData = [[NSData alloc] initWithBase64EncodedString:snapshot.value[@"image"] options:0];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                self.testImageView.image = image;
            } withCancelBlock:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
        }
    }];
}

@end
