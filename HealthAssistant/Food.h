//
//  Food.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodProperty.h"

@interface Food : NSObject
@property NSMutableArray<FoodProperty *> *foodProperties;
@property NSString *foodId;
@end
