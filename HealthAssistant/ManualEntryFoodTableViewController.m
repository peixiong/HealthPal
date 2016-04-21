//
//  ManualEntryFoodTableViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ManualEntryFoodTableViewController.h"
#import "ManualEntryTableViewCell.h"

@interface ManualEntryFoodTableViewController ()

@property NSArray<NSArray *> *infoTypes;
@property NSArray<NSString *> *headers;
@property NSArray<NSArray *> *placeHolders;

@end

@implementation ManualEntryFoodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Creat Your Food";
    self.infoTypes = @[@[@"Restrant/Home", @"Description", @"Serving Size", @"Servings per container"],
                      @[@"Calories (cal)", @"Total Carbohydrates (g)", @"Protein (g)", @"Total Fat (g)", @"Sugar (g)", @"Total Fiber (g)", @"Sodium (mg)", @"Calcium (%)", @"Iron (%)", @"Vitamin A (g)", @"Vitamin C (g)"]];
    self.headers = @[@"Food Information", @"Food Nutritions"];
    self.placeHolders = @[@[@"Optional",@"Required",@"Required",@"Required"],
                        @[@"Required",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional",@"Optional"]];
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
