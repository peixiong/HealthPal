//
//  ChartsViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ChartsViewController.h"
#import "NutritionsTableViewCell.h"



@interface ChartsViewController () <UITableViewDelegate, UITableViewDataSource>

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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Nutritions"];
        //cell.userInteractionEnabled = true;

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
