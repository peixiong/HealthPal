//
//  NutritionCategory.h
//  HealthAssistant
//
//  Created by David Iskander on 4/28/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NutritionCategory : NSObject
@property NSString *title;
@property NSDate *date;
@property NSArray *points;

-(void)getDataFromFireBase;

@end
