//
//  FoodProperty.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, FoodPropertyType) {
    FoodPropertyFoodImageStr         = 0,
    FoodPropertyDescription          = 1,
    FoodPropertyRestrantOrHomemade   = 2,
    FoodPropertyServingSize          = 3,
    FoodPropertyServingsPerContainer = 4,
    FoodPropertyCalories             = 5,
    FoodPropertyTotalCarbohydrates   = 6,
    FoodPropertyProtein              = 7,
    FoodPropertyTotalFat             = 8,
    FoodPropertySuger                = 9,
    FoodPropertyTotalFiber           = 10,
    FoodPropertySodium               = 11,
    FoodPropertyCalcium              = 12,
    FoodPropertyIron                 = 13,
    FoodPropertyVitaminA             = 14,
    FoodPropertyVitaminC             = 15
};

@interface FoodProperty : NSObject

@property int fpId;
@property NSString *name;
@property NSString *placeHolder;
@property NSString *value;



@end
