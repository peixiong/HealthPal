//
//  FoodProperty.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, FoodPropertyType) {
    FoodPropertyDescription          = 0,
    FoodPropertyRestrantOrHomemade   = 1,
    FoodPropertyServingSize          = 2,
    FoodPropertyServingsPerContainer = 3,
    FoodPropertyCalories             = 4,
    FoodPropertyTotalCarbohydrates   = 5,
    FoodPropertyProtein              = 6,
    FoodPropertyTotalFat             = 7,
    FoodPropertySuger                = 8,
    FoodPropertyTotalFiber           = 9,
    FoodPropertySodium               = 10,
    FoodPropertyCalcium              = 11,
    FoodPropertyIron                 = 12,
    FoodPropertyVitaminA             = 13,
    FoodPropertyVitaminC             = 14
};

@interface FoodProperty : NSObject

@property int fpId;
@property NSString *name;
@property NSString *placeHolder;
@property NSString *value;


@end
