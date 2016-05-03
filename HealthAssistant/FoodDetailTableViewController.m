//
//  FoodDetailTableViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 5/2/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "FoodDetailTableViewController.h"

@interface FoodDetailTableViewController ()
@property NSArray<NSArray *> *infoTypes;
@property NSArray *headers;
@property NSArray *values;
@end

@implementation FoodDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user.selectedFoodProperties = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15];
    NSMutableArray *basicInfo = [NSMutableArray new];
    NSMutableArray *nutritionInfo = [NSMutableArray new];
    NSMutableArray *basicValues = [NSMutableArray new];
    NSMutableArray *nutritionValues = [NSMutableArray new];

    for (int i = 1; i<5; i++) {
        FoodProperty *foodProperty = self.food.foodProperties[i];
        [basicInfo addObject:foodProperty.name];
        
        if (self.food.foodProperties[1].value) {
            [basicValues addObject:foodProperty.value];
        }else {
            [basicValues addObject:@""];
        }
    }
    
    for (int i = 5; i<self.user.selectedFoodProperties.count; i++) {
        NSInteger index = [self.user.selectedFoodProperties[i] integerValue];
        FoodProperty *foodProperty = self.food.foodProperties[index];
        [nutritionInfo addObject:foodProperty.name];
        if (self.food.foodProperties[1].value) {
            [nutritionValues addObject:foodProperty.value];
        } else {
            [nutritionValues addObject:@""];
        }
    }
    self.infoTypes = @[basicInfo, nutritionInfo];
    self.headers = @[@"Food Information", @"Food Nutritions"];
    self.values = @[basicValues, nutritionValues];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.infoTypes[section].count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.headers[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail" forIndexPath:indexPath];
    cell.textLabel.text = self.infoTypes[indexPath.section][indexPath.row];
    cell.detailTextLabel.text = self.values[indexPath.section][indexPath.row];
    return cell;
}


@end
