//
//  User.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodProperty.h"
#import <UIKit/UIKit.h>
#import "WaterContainer.h"
@interface User : NSObject

@property NSString *uid;
@property NSString *username;
@property NSString *email;
@property NSString *imageStr;
@property UIImage *image;
@property NSString *birthday;
@property NSString *weight;
@property NSString *height;
@property NSString *gender;
@property NSDictionary *timeFood;
@property NSString *waterGoal;
@property NSArray<NSNumber *> *selectedFoodProperties;
@property NSArray<WaterContainer *> *waterContainers;
@property NSArray<NSDictionary *> *timeWater;
-(BOOL)ifSelected:(int)fpId;

@end
