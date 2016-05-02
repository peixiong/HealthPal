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
        
        self.foodProperties[0].name = @"foodImageStr";
        self.foodProperties[1].name = @"Description";
        self.foodProperties[2].name = @"Restrant/Homemade";
        self.foodProperties[3].name = @"Serving Size";
        self.foodProperties[4].name = @"Servings per Container";
        self.foodProperties[5].name = @"Calories (cal)";
        self.foodProperties[6].name = @"Total Carbohydrates (g)";
        self.foodProperties[7].name = @"Protein (g)";
        self.foodProperties[8].name = @"Total Fat (g)";
        self.foodProperties[9].name = @"Sugar (g)";
        self.foodProperties[10].name = @"Total Fiber (g)";
        self.foodProperties[11].name = @"Sodium (mg)";
        self.foodProperties[12].name = @"Calcium (%)";
        self.foodProperties[13].name = @"Iron (%)";
        self.foodProperties[14].name = @"Vitamin A (%)";
        self.foodProperties[15].name = @"Vitamin C (%)";

        
        self.foodProperties[FoodPropertyDescription].placeHolder = @"Required";
        self.foodProperties[FoodPropertyServingSize].placeHolder = @"Required";
        self.foodProperties[FoodPropertyCalories].placeHolder = @"Required";

        return self;
    }
    return nil;
}

@end
