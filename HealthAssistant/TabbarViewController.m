//
//  TabbarViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "TabbarViewController.h"
#import "EntryNutritionTabBarController.h"
#import "PopUPButton.h"
@interface TabbarViewController () <UITabBarControllerDelegate, PopUPButtonDelegate>

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        UIView *backgroudView = [[UIView alloc]initWithFrame:self.view.frame];
        backgroudView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.25];
        [self.view addSubview:backgroudView];
        float butonWidth = self.view.frame.size.width*0.45;
        float butonHeight = 30.0;
        float buttonOriginX = self.view.frame.size.width*0.3;
        float buttonOriginY = self.view.frame.size.height-self.tabBar.frame.size.height;
        NSArray *buttonTitles = @[@"Scan to add food",@"Manually add food",@"Add water"];
        
        for (int i=0; i<3; i++) {
            PopUPButton *button = [[PopUPButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, butonWidth, butonHeight) title:buttonTitles[i] destinationFrame:CGRectMake(buttonOriginX, buttonOriginY - (3-i)*butonHeight, butonWidth, butonHeight) tag:i];
            [self.view addSubview:button];
            button.delegate = self;
        }
        
        return NO;
    } else {
        return YES;
    }
}

-(void)buttonSelected:(UIButton *)button{
    EntryNutritionTabBarController *enTBVC = [self.viewControllers objectAtIndex:2];
    
    if (button.tag == 0) {
        //scan page pop up
    } else if (button.tag == 1) {
        //show viewcontroller 3
        enTBVC.index = 0;
        [self setSelectedIndex:2];
    } else if (button.tag == 2) {
        //show the water intake view controller
        enTBVC.index = 1;
        [self setSelectedIndex:2];
    }
}

@end
