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
-(NSMutableArray *)keyIDs{
    if (!_keyIDs) {
        _keyIDs = [[NSMutableArray alloc]init];
    }
    return _keyIDs;
}


@end
