//
//  EntryNutritionTabBarController.m
//  
//
//  Created by Pei Xiong on 4/19/16.
//
//

#import "EntryNutritionTabBarController.h"
#import "FoodEntryViewController.h"
#import "ScanViewController.h"
@interface EntryNutritionTabBarController ()

@property float tabbarHeight;

@end

@implementation EntryNutritionTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *nav = [self.viewControllers objectAtIndex:0];
    FoodEntryViewController *fevc = [nav.viewControllers objectAtIndex:0];
    fevc.user = self.user;
    ScanViewController *svc = [self.viewControllers objectAtIndex:1];
    svc.tabbarHeight = self.tabBar.frame.size.height;
    svc.user = self.user;
}

@end
