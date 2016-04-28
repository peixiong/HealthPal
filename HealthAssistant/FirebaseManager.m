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
#import "User.h"
@interface FirebaseManager ()

@property Firebase *rootRef;
@property Firebase *foodsRef;
@property Firebase *usersRef;
@property User *user;
@end


@implementation FirebaseManager

+(instancetype) sharedInstance
{
    static FirebaseManager *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[FirebaseManager alloc] init];
        sInstance.rootRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
        sInstance.foodsRef = [sInstance.rootRef childByAppendingPath:@"foods"];
        sInstance.usersRef = [sInstance.rootRef childByAppendingPath:@"users"];
    });
    return sInstance;
}


//MARK........save food to foods database
-(void)saveToFoodsWithFood:(Food *)food{
    NSMutableArray *foodInfo = [NSMutableArray new];
    for (FoodProperty *foodProperty in food.foodProperties) {
        if (foodProperty.value != nil && foodProperty.value.length >0) {
            [foodInfo addObject:@{@"name":foodProperty.name,
                                  @"fpId":@(foodProperty.fpId),
                                  @"value":foodProperty.value}];
        }
    }
    Firebase *foodRef = [self.foodsRef childByAutoId];
    food.foodId = foodRef.key;
    [foodRef setValue:foodInfo];
}

//add the food to user's path, and create a new food in database
-(void)saveFoodtoUserTimeFoodForUser:(User *)user day:(NSString *)dayStr meal:(NSString *)whichMeal andFood:(Food *)food{
    Firebase *whichMealRef = [self.usersRef childByAppendingPath:[NSString stringWithFormat:@"%@/timeFood/%@/%@",user.uid, dayStr, whichMeal]];
    Firebase *theMealFoodRef = [whichMealRef childByAutoId];
    [theMealFoodRef setValue:food.foodId];
}

//MARK........user login
-(void)loginUserEmail:(NSString *)emailAdress password:(NSString *)password {
    [self.rootRef authUser:emailAdress password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
        if (error) {
            NSLog(@"There was an error: %@", error.localizedDescription);
            [self showAlertWithMessage:@"Email or password are incorrect."];
        } else {
            NSLog(@"We are now logged in with userId = %@", authData.uid);
            [self retrieveUserDataWithUid:authData.uid];
            
        }
    }];
}


//MARK.......retrieve data from firebase using user id
-(void)retrieveUserDataWithUid:(NSString *)uid{
    self.user =[[User alloc] init];
    Firebase *readRef = [self.usersRef childByAppendingPath:[NSString stringWithFormat:@"%@",uid]];
    [readRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        self.user.uid = uid;
        self.user.username = snapshot.value[@"username"];
        self.user.email = snapshot.value[@"email"];
        self.user.imageStr = snapshot.value[@"imageStr"];
        NSData *imageData = [[NSData alloc] initWithBase64EncodedString:self.user.imageStr options:0];
        self.user.image = [[UIImage alloc] initWithData:imageData];
        self.user.selectedFoodProperties = snapshot.value[@"selectedFoodProperties"];
        self.user.timeFood = snapshot.value[@"timeFood"];
        self.user.weight = snapshot.value[@"weight"];
        self.user.height = snapshot.value[@"height"];
        self.user.gender = snapshot.value[@"gender"];
        
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didLoginWithUser:)]) {
            [self.delegate didLoginWithUser:self.user];
        } else {
            NSLog(@"Self.delegate = nil or delegate does not have the (userDidLoginWithUid) method");
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
};


//MARK.....facebook login
-(void)facebookLogin {
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
            [self.rootRef authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                    [self showAlertWithMessage:error.localizedDescription];
                } else {
                    //facebook logged in successfully
                    Firebase *readRef = [self.usersRef childByAppendingPath:[NSString stringWithFormat:@"%@", authData.uid]];
                    [readRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                        if (snapshot.value == [NSNull null]) {
                            //generate new user dictionary
                            NSString *url = authData.providerData[@"profileImageURL"];
                            NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
                            UIImage *image = [UIImage imageWithData:imageData];
                            
                            //compress image size
                            CGSize newSize = CGSizeMake(200, 200);
                            UIGraphicsBeginImageContext(newSize);
                            [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                            UIGraphicsEndImageContext();
                            NSData *newImageData = UIImageJPEGRepresentation(newImage, 0.5);
                            NSString *imageStr = [newImageData base64EncodedStringWithOptions:0];
                            
                            
                            NSDictionary *firebaseUser = @{
                                                           @"username" : authData.providerData[@"displayName"],
                                                           @"email" : authData.providerData[@"email"],
                                                           @"imageStr": imageStr
                                                           };
                            [readRef setValue:firebaseUser];
                            
                            //create user
                            User *user = [User new];
                            user.username = authData.providerData[@"displayName"];
                            user.email = authData.providerData[@"email"];
                            user.imageStr = imageStr;
                            user.image = newImage;
                            [self.delegate didLoginWithUser:user];
                        } else {
                            //user already exist
                            [self retrieveUserDataWithUid:authData.uid];
                            self.user.uid = authData.uid;
                        }
                    }];
                }
            }];
        }
    }];
}





//MARK........sign up
-(void)createNewUserWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password ConfirmedPassword:(NSString *)confirmedPassword andImageStr:(NSString *)imageStr {
    // Create a reference to a Firebase database URL
    [self.rootRef createUser:emailAddress password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
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
            User *user = [User new];
            user.uid = uid;
            user.username = username;
            user.email = emailAddress;
            user.imageStr = imageStr;
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageStr options:0];
            user.image = [[UIImage alloc] initWithData:imageData];
            [self.delegate didLoginWithUser:user];
            //generate user dictionary
            NSDictionary *firebaseUser = @{
                                   @"username" : username,
                                   @"email" : emailAddress,
                                   @"imageStr": imageStr
                                   };
            NSString *path = [NSString stringWithFormat:@"users/%@", uid];
            Firebase *userRef = [self.rootRef childByAppendingPath: path];
            [userRef setValue:firebaseUser];
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
