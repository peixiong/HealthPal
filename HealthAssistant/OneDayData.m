//
//  OneDayData.m
//  HealthAssistant
//
//  Created by David Iskander on 4/28/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "OneDayData.h"

@implementation OneDayData


//Lazy Instantiation
-(NSArray *)keyIDs{
    if (!_keyIDs) {
        _keyIDs = [[NSArray alloc]init];
    }
    return _keyIDs;
}


@end
