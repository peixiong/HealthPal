//
//  FoodListTableViewController.h
//  HealthAssistant
//
//  Created by Pei Xiong on 5/2/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface FoodListTableViewController : UITableViewController
@property NSString *concern;
@property NSString *sortWay;
@property NSInteger selectedFpId;
@property User *user;
@end
