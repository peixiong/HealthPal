//
//  User.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/22/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "User.h"
@implementation User

-(instancetype)init{
    if (self = [super init]) {
        self.timeFood = [NSMutableArray new];
        return self;
    }
    return nil;
}

-(BOOL)ifSelected:(int)fpId {
    for (NSNumber *fp in self.selectedFoodProperties) {
        if ([fp integerValue] == fpId) {
            return true;
        }
    }
    return false;
}

@end
