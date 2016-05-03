//
//  FoodListTableViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 5/2/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "FoodListTableViewController.h"
#import "Food.h"
#import "FoodDetailTableViewController.h"
@interface FoodListTableViewController ()
@property NSMutableArray<Food *> *resultArray;

@end

@implementation FoodListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        [self sendPOSTRequestWithConcern:self.concern andOrder:self.sortWay];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)sendPOSTRequestWithConcern:(NSString *)concern andOrder:(NSString *)order {
    self.resultArray = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:@"https://api.nutritionix.com/v1_1/search"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *tmpJson = [NSMutableDictionary new];
    tmpJson[@"appId"] = @"97e51eca";
    tmpJson[@"appKey"] = @"593a8537db4003bb79f34b9370ae5502";
    tmpJson[@"filters"] = @{@"item_type":@3,
                            @"nf_calories":@{@"from":@2, @"to":@2000},
                            @"nf_total_fat":@{@"from":@1, @"to":@500},
                            @"nf_sodium":@{@"from":@1, @"to":@8000},
                            @"nf_total_carbohydrate":@{@"from":@1, @"to":@5000},
                            @"nf_sugars":@{@"from":@0, @"to":@20},
                            @"nf_dietary_fiber":@{@"from":@0, @"to":@500},
                            };
    
    tmpJson[@"offset"] = @0;
    tmpJson[@"limit"] = @20;
    
    NSMutableDictionary *sortDict = [NSMutableDictionary new];
    sortDict[@"field"] = concern;
    //sortDict[@"order"] = @"desc";
    //sortDict[@"order"] = @"asc";
    sortDict[@"order"] = order;
    tmpJson[@"sort"] = sortDict;
    
    NSArray *fields = @[@"images_front_full_url", @"item_name", @"brand_name", @"nf_calories", @"nf_total_fat", @"nf_sodium", @"nf_total_carbohydrate",@"nf_dietary_fiber",@"nf_sugars",@"nf_protein",@"nf_vitamin_a_dv", @"nf_vitamin_c_dv",@"nf_calcium_dv",@"nf_iron_dv",@"nf_serving_per_container",@"nf_serving_size_qty",@"nf_serving_size_unit",@"nf_serving_weight_grams"];
    tmpJson[@"fields"] = fields;
    
    NSLog(@"tmpJson = %@", tmpJson.description);
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmpJson options:0 error:&error];
    NSLog(@"postData = %@", postData.description);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        NSArray *resultArray = respDict[@"hits"];
        if (jsonError) {
            NSLog(@"there is an error loading Json data");
        } else {
            for (NSDictionary *dict in resultArray) {
                Food *food = [Food new];
                NSDictionary *fieldsDict = dict[@"fields"];
                food.foodProperties[1].value = fieldsDict[@"item_name"];
                food.foodProperties[2].value = [NSString stringWithString:fieldsDict[@"brand_name"]];
                food.foodProperties[3].value = [NSString stringWithFormat:@"%@ %@", fieldsDict[@"nf_serving_size_qty"], fieldsDict[@"nf_serving_size_unit"]];
                food.foodProperties[4].value = @"1";
                food.foodProperties[5].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_calories"]];
                food.foodProperties[6].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_total_carbohydrate"]];
                food.foodProperties[7].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_protein"]];
                food.foodProperties[8].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_total_fat"]];
                food.foodProperties[9].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_sugars"]];
                food.foodProperties[10].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_dietary_fiber"]];
                food.foodProperties[11].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_sodium"]];
                food.foodProperties[12].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_calcium_dv"]];
                food.foodProperties[13].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_iron_dv"]];
                food.foodProperties[14].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_vitamin_a_dv"]];
                food.foodProperties[15].value = [NSString stringWithFormat:@"%@", fieldsDict[@"nf_vitamin_c_dv"]];
                if ([food.foodProperties[2].value isEqualToString:@"Nutritionix"]) {
                    food.foodProperties[2].value = @"";
                }
                for (int i = 5; i<food.foodProperties.count; i++) {
                    if ([food.foodProperties[i].value isEqualToString:@"<null>"]) {
                        food.foodProperties[i].value = @"";
                    }
                    food.foodProperties[i].value = [NSString stringWithFormat:@"%li", (long)[food.foodProperties[i].value integerValue]];
                }
                [self.resultArray addObject:food];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        NSLog(@"there are %lu objects loaded from json",(unsigned long)resultArray.count);
        NSLog(@"%@",resultArray.description);
    }];
    [task resume];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"suggestedFoodCell" forIndexPath:indexPath];
    
    Food *food = self.resultArray[indexPath.row];
    cell.textLabel.text = food.foodProperties[1].value;
    NSString *value = food.foodProperties[self.selectedFpId].value;
    NSString *unit;
    if (self.selectedFpId == 5) {
        unit = @"cal";
    } else if (self.selectedFpId==6 || self.selectedFpId==7 ||self.selectedFpId==8 || self.selectedFpId==9 || self.selectedFpId==10 ) {
        unit = @"g";
    } else if (self.selectedFpId==11){
        unit = @"mg";
    } else {
        unit = @"%";
    }
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", value, unit];
    return cell;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    FoodDetailTableViewController *dvc = segue.destinationViewController;
    dvc.food = self.resultArray[indexPath.row];
    dvc.user = self.user;
}

@end
