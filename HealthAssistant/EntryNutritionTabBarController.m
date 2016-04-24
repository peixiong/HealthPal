//
//  EntryNutritionTabBarController.m
//  
//
//  Created by Pei Xiong on 4/19/16.
//
//

#import "EntryNutritionTabBarController.h"
#import "FoodEntryViewController.h"

@interface EntryNutritionTabBarController ()

@end

@implementation EntryNutritionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *nav = [self.viewControllers objectAtIndex:0];
    FoodEntryViewController *fevc = [nav.viewControllers objectAtIndex:0];
    fevc.user = self.user;
}

@end
