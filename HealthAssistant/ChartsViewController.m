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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // return appropriate cell(s) based on section
    if(indexPath.row == 0)
    {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: @"nutritionsCell"];
    }if (indexPath.row == 1){
        // do stuff
    }else {
        // do stuff
    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




@end
