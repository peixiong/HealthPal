//
//  SelectedNutritionTarget.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/23/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectedNutritionTarget : NSObject

@property NSString *name;
@property NSString *selected;
@property int suggested;
@property NSString *unit;
@property int sliderMax;

@end
