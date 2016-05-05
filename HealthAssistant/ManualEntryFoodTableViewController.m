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
#import "TabbarViewController.h"
#import "FoodEntryViewController.h"
@interface ManualEntryFoodTableViewController () <FirebaseManagerDelegate, ManualEntryTableViewCellDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, LunchImageTableViewCellDelegate, UIScrollViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property NSArray<NSArray *> *infoTypes;
@property NSArray<NSString *> *headers;
@property NSArray<NSArray *> *placeHolders;
@property NSArray<NSMutableArray *> *textFieldValues;
@property NSMutableArray<NSString *> *foodValues;
@property FoodProperty *foodProperty;
@property NSMutableArray<FoodProperty *> *selected;
@property UIImage *foodImage;
@property NSArray *colorArray;
@property NSString *whichMeal;

@end

@implementation ManualEntryFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FirebaseManager sharedInstance].delegate = self;
    self.navigationItem.title = @"Creat Your Food";
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.foodImage = [UIImage imageNamed:@"raspberries-1"];
    //test data for user.selectedFoodProperties
    self.user.selectedFoodProperties = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11, @12, @13, @14, @15];
    self.colorArray  = [[NSArray alloc] initWithObjects:@"Breakfast",@"Lunch",@"Dinner",@"Snack", nil];
    self.whichMeal = @"Dinner";
    self.textFieldValues = [NSArray new];
    
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
        } else {
            [basicValues addObject:@""];
        }
    }
    for (int i = 5; i<self.user.selectedFoodProperties.count; i++) {
        NSInteger index = [self.user.selectedFoodProperties[i] integerValue];
        FoodProperty *foodProperty = self.food.foodProperties[index];
        [nutritionInfo addObject:foodProperty.name];
        [nutritionInfoPlaceHolders addObject:foodProperty.placeHolder];
        if (self.food.foodProperties[1].value) {
        [nutritionValues addObject:foodProperty.value];
        } else {
            [nutritionValues addObject:@""];
        }
    }
    self.infoTypes = @[basicInfo, nutritionInfo];
    self.headers = @[@"Food Information", @"Food Nutritions"];
    self.placeHolders = @[basicInfoPlaceHolders,nutritionInfoPlaceHolders];
    self.textFieldValues = @[basicValues, nutritionValues];
}


- (IBAction)onDoneButtonPressed:(UIBarButtonItem *)sender {
    // Manually fire textFieldDidEndEditing events for all textfields visable:
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        if (indexPath.section != 0) {
            ManualEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
        }
    }
    FoodProperty *fp1 = self.food.foodProperties[1];
    FoodProperty *fp3 = self.food.foodProperties[3];
    FoodProperty *fp5 = self.food.foodProperties[5];
    if (fp1.value == nil || fp3.value == nil || fp5.value == nil) {
        [self showAlertWithMessage:@"Pls fill all the required fields."];
        return;
    }
    
    [[FirebaseManager sharedInstance] saveToFoodsWithFood:self.food];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyyMMdd"];
    [DateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dayStr = [DateFormatter stringFromDate:[NSDate date]];
    
    [[FirebaseManager sharedInstance] saveFoodtoUserTimeFoodForUser:self.user day:dayStr meal:self.whichMeal andFood:self.food];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    for (NSIndexPath *indexPath in self.tableView.indexPathsForVisibleRows) {
        if (indexPath.section != 0) {
            ManualEntryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
        }
    }
}

-(void)textFieldDidChangedWithCell:(ManualEntryTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    if (indexPath.section == 1) {
        self.food.foodProperties[indexPath.row+1].value = cell.textField.text;
        self.textFieldValues[indexPath.section-1][indexPath.row] = cell.textField.text;//.......
        [self.tableView reloadData];
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
    //to keep the tabbar
//    imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self.navigationController presentViewController:imagePicker animated:NO completion:nil];
    [segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    TabbarViewController *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainTabbar"];
    tvc.tabBar.hidden = true;
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
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    TabbarViewController *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainTabbar"];
    tvc.tabBar.hidden = false;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    TabbarViewController *tvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainTabbar"];
    tvc.tabBar.hidden = false;
    [picker dismissViewControllerAnimated:NO completion:nil];
}

-(void)didLoginWithUser:(User *)user{
    self.user = user;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component
{
    return [self.colorArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    switch(row)
    {
        case 0:
            self.whichMeal = @"Breakfast";
            break;
        case 1:
            self.whichMeal = @"Lunch";
            break;
        case 2:
            self.whichMeal = @"Dinner";
            break;
        case 3:
            self.whichMeal = @"Snack";
            break;
    }
}

@end
