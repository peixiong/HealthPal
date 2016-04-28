//
//  ChartsViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ChartsViewController.h"
#import "NutritionsTableViewCell.h"
#import "FirebaseManager.h"
#import "Food.h"


@interface ChartsViewController () <UITableViewDelegate, UITableViewDataSource, FirebaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Food *food;

@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FirebaseManager sharedInstance].delegate = self;
    
    NSDictionary *dict;
    [dict allKeys];
    
    NSLog(@"ChartsVC, this is the user being passed: %@",self.user.uid);
    NSLog(@"ChartsVC, this is the user's food: %@",self.user.timeFood );

    for (NSString *key in self.user.timeFood.allKeys) {
        NSLog(@"%@", key);
        NSDictionary *food = self.user.timeFood[key];
//        for (NSString *foodKey in food.allKeys) {
//            NSLog(@"%@", food[foodKey]);
//        }
//        NSLog(@"%@", food[@"Breakfast"]);
//        NSLog(@"%@", food[@"Lunch"]);
        NSDictionary *breakfast = food[@"Breakfast"];
        NSLog(@"food value: %@", breakfast.allValues);
//        NSLog(@"breakfast food key: %@", breakfast.allKeys);
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    // return appropriate cell(s) based on row
    if(indexPath.row == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nutritions"];
        return cell;
        
    }if (indexPath.row == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Water"];
        return cell;
        
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activities"];
        return cell;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}







@end
