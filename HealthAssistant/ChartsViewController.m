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
    
    
    //Retriving data
    [FirebaseManager sharedInstance].delegate = self;
    NSLog(@"ChartsVC, this is the user being passed: %@",self.user.uid);

    for (NSString *key in self.user.timeFood.allKeys) {
        NSDictionary *food = self.user.timeFood[key];
        
        NSArray * foodValues = food.allValues;
        //NSLog(@"This is self.foodIDs: %@",self.foodIDs);
        
        for (NSArray *singleEntry in foodValues){
            
            for (NSString *singleID in singleEntry){
                NSLog(@"This is ID: %@",singleID);
                
                [self.foodIDs addObject:singleID];
                NSLog(@"This is Array of IDs: %@",self.foodIDs);

            }
        }
        
    }
    //NSLog(@"This is Array of IDs: %@",self.foodIDs);

    
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
