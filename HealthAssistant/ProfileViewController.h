//
//  ProfileViewController.h
//  
//
//  Created by Pei Xiong on 4/18/16.
//
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ProfileViewController : UIViewController

@property User *user;
@property NSArray *goalNames;

@property NSArray *suggestedValueFemale19to50Age;

@property NSArray *suggestedValueMale1930Age;
@property NSArray *suggestedValueMale3150Age;



@end
