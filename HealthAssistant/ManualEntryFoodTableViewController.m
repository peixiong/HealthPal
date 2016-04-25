//
//  ManualEntryFoodTableViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ManualEntryFoodTableViewController.h"
#import "ManualEntryTableViewCell.h"
#import "FirebaseManager.h"
#import "food.h"
#import "foodProperty.h"
@interface ManualEntryFoodTableViewController () <FirebaseManagerDelegate, ManualEntryTableViewCellDelegate, UITextFieldDelegate>

@property NSArray<NSArray *> *infoTypes;
@property NSArray<NSString *> *headers;
@property NSArray<NSArray *> *placeHolders;
@property NSMutableArray<NSString *> *foodValues;
@property Food *food;
@property FoodProperty *foodProperty;
@property NSMutableArray<FoodProperty *> *selected;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ManualEntryFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FirebaseManager sharedInstance].delegate = self;
    self.navigationItem.title = @"Creat Your Food";
    self.food = [Food new];

    //test date for user.selectedFoodProperties
    self.user.selectedFoodProperties = @[@0, @1, @2, @3, @4, @5, @9];
    
    self.selected = [NSMutableArray new];
    for (int i =0; i< self.food.foodProperties.count; i++) {
        if ([self.user ifSelected:self.food.foodProperties[i].fpId]) {
            [self.selected addObject:self.food.foodProperties[i]];
        }
        
    }
    
    NSMutableArray *basicInfo = [NSMutableArray new];
    NSMutableArray *nutritionInfo = [NSMutableArray new];
    NSMutableArray *basicInfoPlaceHolders = [NSMutableArray new];
    NSMutableArray *nutritionInfoPlaceHolders = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        [basicInfo addObject:self.selected[i].name];
        [basicInfoPlaceHolders addObject:self.selected[i].placeHolder];
    }
    for (int i = 4; i<self.selected.count; i++) {
        [nutritionInfo addObject:self.selected[i].name];
        [nutritionInfoPlaceHolders addObject:self.selected[i].placeHolder];
    }
    self.infoTypes = @[basicInfo, nutritionInfo];
    self.headers = @[@"Food Information", @"Food Nutritions"];
    self.placeHolders = @[basicInfoPlaceHolders,nutritionInfoPlaceHolders];
}


- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender {
    // Manually fire textFieldDidEndEditing events for all textfields visable:
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        ManualEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.textField resignFirstResponder];
    }

    Food *food = [Food new];
    for (FoodProperty *foodProperty in self.selected) {
        if (foodProperty.value != nil) {
            food.foodProperties[foodProperty.fpId].value = foodProperty.value;
        }
    }
        
    [[FirebaseManager sharedInstance] saveToFoodsWithFood:food];
}




-(void)textFieldDidChangedWithCell:(ManualEntryTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == 0) {
        self.selected[indexPath.row].value = cell.textField.text;
    } else {
        self.selected[indexPath.row + [self.tableView numberOfRowsInSection:0]].value = cell.textField.text;
    };
    NSLog(@"indexPath.row = %li", (long)indexPath.row);
    NSLog(@"indexPath.section = %li", (long)indexPath.section);
    NSLog(@"string = %@", cell.textField.text);
    //infirebase, set the key value to be "string"
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infoTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infoTypes[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ManualEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    cell.delegate = self;
    cell.typeLabel.text = self.infoTypes[indexPath.section][indexPath.row];
    cell.textField.placeholder = self.placeHolders[indexPath.section][indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section < self.headers.count) {
        return self.headers[section];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ManualEntryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textField becomeFirstResponder];
}

@end
