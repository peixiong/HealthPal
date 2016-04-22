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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@implementation FirebaseManager

+(instancetype) sharedInstance
{
    static FirebaseManager *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[FirebaseManager alloc] init];
    });
    return sInstance;
}

+(Firebase *)sharedRootRef {
    static Firebase *rootRef;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        rootRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    });
    return rootRef;
}

//MARK........user login
-(void)loginUserEmail:(NSString *)emailAdress password:(NSString *)password {
    Firebase *ref = [FirebaseManager sharedRootRef];
    [ref authUser:emailAdress password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            NSLog(@"There was an error: %@", error.localizedDescription);
            [self showAlertWithMessage:@"Email or password are incorrect."];
        } else {
            NSLog(@"We are now logged in with userId = %@", authData.uid);
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(userDidLoginWithUid:)]) {
                [self.delegate userDidLoginWithUid:authData.uid];
            } else {
                NSLog(@"Self.delegate = nil or delegate does not have the (userDidLoginWithUid) method");
            }
        }
    }];
}


//MARK.....facebook login
-(void)facebookLogin {
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:(UIViewController *)(self.delegate) handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Facebook login failed. Error: %@", error);
            [self showAlertWithMessage:error.localizedDescription];
        } else if (result.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
            [self showAlertWithMessage:@"Facebook login is cancelled"];
        } else {
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            [ref authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                    [self showAlertWithMessage:error.localizedDescription];
                } else {
                    [self.delegate userDidLoginWithUid:authData.uid];
                    //if in firebase, users/uid = nil, setvalue
                    //if user/uid != nil,
//                    NSLog(@"Logged in! %@", authData);
//                    NSLog(@"facebook usename = [%@]", authData.providerData[@"displayName"]);
//                    NSLog(@"facebook login email = [%@]", authData.providerData[@"email"]);
//                    NSString *url = authData.providerData[@"profileImageURL"];
//                    NSLog(@"facebook profile image url = [%@]", url);
//                    //UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
//                    //self.testImageView.image = image;
                }
            }];
        }
    }];
}


//MARK.......retrieve data from firebase using user id

//        NSString *url = [NSString stringWithFormat:@"https://blinding-heat-8730.firebaseio.com/users/%@", authData.uid];
//        Firebase *readRef = [[Firebase alloc] initWithUrl:url];
//        
//        [readRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//            NSLog(@"%@", snapshot.value);
//            NSLog(@"username = [%@]", snapshot.value[@"username"]);
//            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:snapshot.value[@"image"] options:0];
//            UIImage *image = [[UIImage alloc] initWithData:imageData];
//        } withCancelBlock:^(NSError *error) {
//            NSLog(@"%@", error.description);
//        }];
//}];


//MARK........sign up
-(void)createNewUserWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password ConfirmedPassword:(NSString *)confirmedPassword andImageStr:(NSString *)imageStr {
    // Create a reference to a Firebase database URL
    Firebase *ref = [FirebaseManager sharedRootRef];
    [ref createUser:emailAddress password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
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
            [self.delegate userDidLoginWithUid:uid];
            //generate user dictionary
            NSDictionary *user = @{
                                   @"username" : username,
                                   @"email" : emailAddress,
                                   @"imageStr": imageStr
                                   };
            NSString *path = [NSString stringWithFormat:@"users/%@", uid];
            Firebase *userRef = [ref childByAppendingPath: path];
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
