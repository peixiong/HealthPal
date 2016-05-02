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
#import "AddWaterViewController.h"
#import "SuggestionViewController.h"
#import "FirebaseManager.h"
#import "ProfileViewController.h"

@interface TabbarViewController () <UITabBarControllerDelegate, PopUPButtonDelegate, FirebaseManagerDelegate>
@property NSMutableArray<UIButton *> *buttonsArray;
@property UIView *backgroundView;
@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[FirebaseManager sharedInstance].delegate = self;
    self.buttonsArray = [NSMutableArray new];
    self.delegate = self;
    ChartsViewController *cvc = [self.viewControllers objectAtIndex:0];
    AddWaterViewController *avc = [self.viewControllers objectAtIndex:1];
    SuggestionViewController *svc = [self.viewControllers objectAtIndex:3];
    ProfileViewController *uvc = [self.viewControllers objectAtIndex:4];
    EntryNutritionTabBarController *entbvc = [self.viewControllers objectAtIndex:2];
    cvc.user = self.user;
    avc.user = self.user;
    svc.user = self.user;
    uvc.user = self.user;
    entbvc.user = self.user;
}

-(void)didLoginWithUser:(User *)user{

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
    float butonHeight = 50.0;
    float buttonOriginX = self.view.frame.size.width*0.3;
    float buttonOriginY = self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height;
    NSArray *buttonTitles = @[@"Scan to add food",@"Manually add food",@"Add water"];
    NSArray *buttonBackgroundColors = @[[UIColor colorWithRed:0.149 green:0.902 blue:0.675 alpha:1.0], [UIColor colorWithRed:0.196 green:0.592 blue:0.898 alpha:1.0]];
    for (int i=0; i<2; i++) {
        PopUPButton *button = [[PopUPButton alloc] initWithFrame:CGRectMake(buttonOriginX, buttonOriginY, butonWidth, butonHeight) title:buttonTitles[i] destinationFrame:CGRectMake(buttonOriginX, buttonOriginY - (2-i)*butonHeight, butonWidth, butonHeight) tag:i];
        button.backgroundColor = buttonBackgroundColors[i];
        button.layer.borderWidth = 0;
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
        [self setSelectedIndex:2];
        [enTBVC setSelectedIndex:1];
    } else if (button.tag == 1) {
        //show viewcontroller 3
        [self setSelectedIndex:2];
        [enTBVC setSelectedIndex:0];
    }
}

@end
