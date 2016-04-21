//
//  FirebaseManager.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "FirebaseManager.h"
#import <Firebase/Firebase.h>
#import <UIKit/UIKit.h>
@implementation FirebaseManager

+ (instancetype)sharedInstance
{
    static FirebaseManager *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[FirebaseManager alloc] init];
    });
    return sInstance;
}


-(void)createNewUserWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password ConfirmedPassword:(NSString *)confirmedPassword andImageStr:(NSString *)imageStr {
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    [myRootRef createUser:emailAddress password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        NSString *alertMessage;
        if (username.length == 0 || emailAddress.length == 0 || password.length == 0 || confirmedPassword.length == 0) {
            alertMessage = @"One of the required fields is empty";
        } else if (![password isEqualToString:confirmedPassword]) {
            alertMessage = @"Password are different";
        } else if (error){
            NSLog(@"There was an error creating the account, error: %@", error.localizedDescription);
            alertMessage = error.localizedDescription;
        }

        if (alertMessage != nil) {
            [self showAlertWithMessage:alertMessage];
        } else {
            //get data from firebase
            NSString *uid = [result objectForKey:@"uid"];
            NSLog(@"Successfully created user account with uid: %@", uid);
            
            //generate user dictionary
            NSDictionary *user = @{
                                   @"username" : username,
                                   @"email" : emailAddress
                                   };
            NSString *path = [NSString stringWithFormat:@"users/%@", uid];
            Firebase *userRef = [myRootRef childByAppendingPath: path];
            [userRef setValue:user];
        }
    }];
}

-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIViewController *constDelegate = (UIViewController *)self.delegate;
    [constDelegate presentViewController:alert animated:true completion:nil];
}

@end
