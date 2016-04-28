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
#import "foodProperty.h"
#import "LunchImageTableViewCell.h"
@interface ManualEntryFoodTableViewController () <FirebaseManagerDelegate, ManualEntryTableViewCellDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, LunchImageTableViewCellDelegate, UIScrollViewDelegate>

@property NSArray<NSArray *> *infoTypes;
@property NSArray<NSString *> *headers;
@property NSArray<NSArray *> *placeHolders;
@property NSArray<NSArray *> *textFieldValues;
@property NSMutableArray<NSString *> *foodValues;
@property FoodProperty *foodProperty;
@property NSMutableArray<FoodProperty *> *selected;
@property NSString *meal;
@property UIImage *foodImage;

@end

@implementation ManualEntryFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FirebaseManager sharedInstance].delegate = self;
    self.navigationItem.title = @"Creat Your Food";
    //self.food = [Food new];
    self.foodImage = [UIImage imageNamed:@"007Squirtle_Pokemon_Mystery_Dungeon_Explorers_of_Sky"];
    //test data for user.selectedFoodProperties
    self.user.selectedFoodProperties = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15];

    
    NSMutableArray *basicInfo = [NSMutableArray new];
    NSMutableArray *nutritionInfo = [NSMutableArray new];
    NSMutableArray *basicValues = [NSMutableArray new];
    NSMutableArray *nutritionValues = [NSMutableArray new];
    NSMutableArray *basicInfoPlaceHolders = [NSMutableArray new];
    NSMutableArray *nutritionInfoPlaceHolders = [NSMutableArray new];
    for (int i = 1; i<5; i++) {
        NSInteger index = [self.user.selectedFoodProperties[i] integerValue];
        if (self.food == nil) {
            self.food = [Food new];
        }
        FoodProperty *foodProperty = self.food.foodProperties[index];
        [basicInfo addObject:foodProperty.name];
        [basicInfoPlaceHolders addObject:foodProperty.placeHolder];
        
        if (self.food.foodProperties[1].value) {
            [basicValues addObject:foodProperty.value];
        }
    }
    for (int i = 5; i<self.user.selectedFoodProperties.count; i++) {
        NSInteger index = [self.user.selectedFoodProperties[i] integerValue];
        FoodProperty *foodProperty = self.food.foodProperties[index];
        [nutritionInfo addObject:foodProperty.name];
        [nutritionInfoPlaceHolders addObject:foodProperty.placeHolder];
        if (self.food.foodProperties[1].value) {
        [nutritionValues addObject:foodProperty.value];
        }
    }
    self.infoTypes = @[basicInfo, nutritionInfo];
    self.headers = @[@"Food Information", @"Food Nutritions"];
    self.placeHolders = @[basicInfoPlaceHolders,nutritionInfoPlaceHolders];
    if (self.food.foodProperties[1].value) {
    self.textFieldValues = @[basicValues, nutritionValues];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:false];
}
- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender {
    // Manually fire textFieldDidEndEditing events for all textfields visable:
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        if (indexPath.section != 0) {
            ManualEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
        }
    }
    
    [[FirebaseManager sharedInstance] saveToFoodsWithFood:self.food];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyyMMdd"];
    [DateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dayStr = [DateFormatter stringFromDate:[NSDate date]];
    
    [[FirebaseManager sharedInstance] saveFoodtoUserTimeFoodForUser:self.user day:dayStr meal:self.meal andFood:self.food];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        if (indexPath.section != 0) {
            ManualEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
        }
    }
}

- (IBAction)onMealButtonPressed:(UIButton *)sender {
    if (sender.tag == 0) {
        self.meal = @"Breakfast";
    } else if (sender.tag == 1) {
        self.meal = @"Lunch";
    } else if (sender.tag == 2) {
        self.meal = @"Dinner";
    } else if (sender.tag == 3) {
        self.meal = @"Snack";
    }
    sender.backgroundColor = [UIColor grayColor];
}


-(void)textFieldDidChangedWithCell:(ManualEntryTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == 1) {
        self.food.foodProperties[indexPath.row+1].value = cell.textField.text;
    } else if (indexPath.section == 2){
        self.food.foodProperties[indexPath.row + [self.tableView numberOfRowsInSection:1]+1].value = cell.textField.text;
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.infoTypes.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.infoTypes[section-1].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LunchImageTableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        cell.foodImageView.image = self.foodImage;
        cell.delegate = self;
        return cell;
    } else {
        ManualEntryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
        cell.delegate = self;
        cell.typeLabel.text = self.infoTypes[indexPath.section-1][indexPath.row];
        cell.textField.placeholder = self.placeHolders[indexPath.section-1][indexPath.row];
        cell.textField.text = self.textFieldValues[indexPath.section-1][indexPath.row];
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        return self.headers[section-1];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LunchImageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else{
        ManualEntryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textField becomeFirstResponder];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 180.0;
    } else {
        return 40.0;
    }
}

-(void)imageDidChangedWithCell:(LunchImageTableViewCell *)cell andSegmentControl:(UISegmentedControl *)segmentControl{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = true;
    if (segmentControl.selectedSegmentIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:imagePicker animated:true completion:nil];
    [segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    
    //compress image size
    CGSize newSize = CGSizeMake(250, 250);
    UIGraphicsBeginImageContext(newSize);
    [editedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:0];
    self.food.foodProperties[0].value = imageStr;
    
    self.foodImage = newImage;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    LunchImageTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.foodImageView.image = newImage;
 
    [self dismissViewControllerAnimated:picker completion:nil];
}

-(void)didLoginWithUser:(User *)user{
    self.user = user;
}

@end
