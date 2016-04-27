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
#import "ChartsViewController.h"
#import "GroupViewController.h"
#import "SuggestionViewController.h"
#import "ProfileViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate, PopUPButtonDelegate>
@property NSMutableArray<UIButton *> *buttonsArray;
@property UIView *backgroundView;
@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ChartsViewController *cvc = [self.viewControllers objectAtIndex:0];
    GroupViewController *gvc = [self.viewControllers objectAtIndex:1];
    SuggestionViewController *svc = [self.viewControllers objectAtIndex:3];
    ProfileViewController *uvc = [self.viewControllers objectAtIndex:4];
    EntryNutritionTabBarController *entbvc = [self.viewControllers objectAtIndex:2];
    cvc.user = self.user;
    gvc.user = self.user;
    svc.user = self.user;
    uvc.user = self.user;
    entbvc.user = self.user;
    
    self.buttonsArray = [NSMutableArray new];
    self.delegate = self;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    if (viewController == [tabBarController.viewControllers objectAtIndex:2]) {
        [self generatePopUpButtons];
        return NO;
    } else {
        return YES;
    }
}


-(void)generateBackgroundViewWithTapGestureRecognizer {
    self.backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    self.backgroundView.backgroundColor = [[UIColor alloc]initWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.backgroundView];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(popDownButtons)];
    [self.backgroundView addGestureRecognizer:singleFingerTap];
}

-(void)generatePopUpButtons{
    [self generateBackgroundViewWithTapGestureRecognizer];
    float butonWidth = self.view.frame.size.width*0.45;
    float butonHeight = 30.0;
    float buttonOriginX = self.view.frame.size.width*0.3;
    float buttonOriginY = self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height;
    NSArray *buttonTitles = @[@"Scan to add food",@"Manually add food",@"Add water"];
    
    for (int i=0; i<3; i++) {
        PopUPButton *button = [[PopUPButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, butonWidth, butonHeight) title:buttonTitles[i] destinationFrame:CGRectMake(buttonOriginX, buttonOriginY - (3-i)*butonHeight, butonWidth, butonHeight) tag:i];
        [self.view addSubview:button];
        [self.buttonsArray addObject:button];
        button.delegate = self;
    }
}


-(void)popDownButtons{
    [self.backgroundView removeFromSuperview];
    for (PopUPButton *button in self.buttonsArray) {
        [button popDownToLowerCenterAndDispear];
    }
}

-(void)buttonSelected:(UIButton *)button{
    [self popDownButtons];
    EntryNutritionTabBarController *enTBVC = [self.viewControllers objectAtIndex:2];
    if (button.tag == 0) {
        //scan page pop up
    } else if (button.tag == 1) {
        //show viewcontroller 3
        [self setSelectedIndex:2];
        [enTBVC setSelectedIndex:0];
    } else if (button.tag == 2) {
        //show the water intake view controller
        [self setSelectedIndex:2];
        [enTBVC setSelectedIndex:1];
    }
}

@end
