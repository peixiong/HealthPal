//
//  ManualEntryFoodTableViewController.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Food.h"
@interface ManualEntryFoodTableViewController : UITableViewController
@property User *user;
@property Food *food;
@end
