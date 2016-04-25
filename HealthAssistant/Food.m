//
//  Food.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "Food.h"
@implementation Food

-(instancetype)init{
    if (self = [super init]) {
        self.foodProperties = [NSMutableArray new];
        
        for (int i = 0; i<= FoodPropertyVitaminC; i++) {
            FoodProperty *property = [FoodProperty new];
            property.fpId = i;
            property.placeHolder = @"Optional";
            [self.foodProperties addObject:property];
        }
        
        self.foodProperties[0].name = @"Description";
        self.foodProperties[1].name = @"Restrant/Homemade";
        self.foodProperties[2].name = @"Serving Size";
        self.foodProperties[3].name = @"Servings per Container";
        self.foodProperties[4].name = @"Calories (cal)";
        self.foodProperties[5].name = @"Total Carbohydrates (g)";
        self.foodProperties[6].name = @"Protein (g)";
        self.foodProperties[7].name = @"Total Fat (g)";
        self.foodProperties[8].name = @"Sugar (g)";
        self.foodProperties[9].name = @"Total Fiber (g)";
        self.foodProperties[10].name = @"Sodium (g)";
        self.foodProperties[11].name = @"Calcium (%)";
        self.foodProperties[12].name = @"Iron (%)";
        self.foodProperties[13].name = @"Vitamin A (%)";
        self.foodProperties[14].name = @"Vitamin C (%)";
        
        self.foodProperties[FoodPropertyDescription].placeHolder = @"Required";
        self.foodProperties[FoodPropertyServingSize].placeHolder = @"Required";
        self.foodProperties[FoodPropertyServingsPerContainer].placeHolder = @"Required";
        self.foodProperties[FoodPropertyCalories].placeHolder = @"Required";
        self.foodProperties[FoodPropertyTotalCarbohydrates].placeHolder = @"Required";

        return self;
    }
    return nil;
}

@end
