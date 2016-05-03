//
//  FoodDetailTableViewController.h
//  HealthAssistant
//
//  Created by Pei Xiong on 5/2/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "User.h"
@interface FoodDetailTableViewController : UITableViewController

@property Food *food;
@property User *user;

@end
