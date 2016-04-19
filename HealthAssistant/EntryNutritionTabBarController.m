//
//  EntryNutritionTabBarController.m
//  
//
//  Created by Pei Xiong on 4/19/16.
//
//

#import "EntryNutritionTabBarController.h"

@interface EntryNutritionTabBarController ()

@end

@implementation EntryNutritionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.index ==0) {
        [self setSelectedIndex:self.index];
        //do the add food stuff in this view controller
    } else if (self.index == 1){
        [self setSelectedIndex:self.index];
        //do the add food stuff in this view controller
    }
}

@end
