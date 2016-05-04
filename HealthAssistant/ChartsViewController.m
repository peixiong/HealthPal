//
//  ChartsViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ChartsViewController.h"
#import "NutritionsTableViewCell.h"
#import "WaterTableViewCell.h"
#import "ActivitiesTableViewCell.h"

#import "FirebaseManager.h"
#import "Food.h"
#import "OneDayData.h"
#import "User.h"


@interface ChartsViewController () <UITableViewDelegate, UITableViewDataSource, FirebaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // return appropriate cell(s) based on row
    if(indexPath.row == 0)
    {
        NutritionsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nutritions"];
        
        cell.user = self.user;
        [cell loadCell];
        return cell;
    }
    
//    }if (indexPath.row == 1){
//        WaterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Water"];
//        //cell.user = self.user;
//        return cell;
//        
//    }else {
//        ActivitiesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Activities"];
//        //cell.user = self.user;
//        return cell;
//    }
    else
    {
        return nil;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return self.view.frame.size.height-100;
    
}



@end
