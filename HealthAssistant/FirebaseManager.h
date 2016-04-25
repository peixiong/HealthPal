//
//  FirebaseManager.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "User.h"
#import "Food.h"

@protocol FirebaseManagerDelegate <NSObject>
@optional
-(void)didLoginWithUser:(User *)user;

@end

@interface FirebaseManager : NSObject

+ (instancetype)sharedInstance;

@property id<FirebaseManagerDelegate> delegate;
-(void)facebookLogin;
-(void)loginUserEmail:(NSString *)emailAdress password:(NSString *)password;
-(void)createNewUserWithUsername:(NSString *)username emailAddress:(NSString *)emailAddress password:(NSString *)password ConfirmedPassword:(NSString *)confirmedPassword andImageStr:(NSString *)imageStr;
-(void)saveToFoodsWithFood:(Food *)food;
-(void)saveFoodtoUserTimeFoodForDay:(NSString *)dayStr meal:(NSString *)whichMeal andFood:(Food *)food;

@end
