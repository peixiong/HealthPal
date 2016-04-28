//
//  ChartsViewController.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ChartsViewController : UIViewController
@property User *user;
@property NSMutableArray *foodIDs;

@end
