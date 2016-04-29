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
#import "OneDayData.h"


@interface ChartsViewController () <UITableViewDelegate, UITableViewDataSource, FirebaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property Food *food;

@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [FirebaseManager sharedInstance].delegate = self;
    
    [self retriveLifetimeUserLoggedFoodIDs];

}


-(void)retriveLifetimeUserLoggedFoodIDs{
    
    self.dataForAllDays = [[NSMutableArray alloc]init];
    for (NSString *dateString in self.user.timeFood.allKeys) {
        OneDayData *oneDay = [[OneDayData alloc]init];
        oneDay.date = dateString;
        NSDictionary *food = self.user.timeFood[dateString];
        NSArray * foodValues = food.allValues;        
        for (NSDictionary *singleEntry in foodValues){
            for (NSString *singleID in singleEntry.allValues){
                [self retriveTotalNutritionsToEachDay:singleID];
            }
        }
        [self.dataForAllDays addObject:oneDay];
    }
}


-(void)retriveTotalNutritionsToEachDay:(NSString *)fid{
    Firebase *ref = [[Firebase alloc] initWithUrl: @"https://blinding-heat-8730.firebaseio.com/"];
    [ref observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        NSDictionary *dict = snapshot.value[@"foods"];

        for (NSString *key in dict.allKeys) {
            if ([key isEqualToString:fid]) {
                NSLog(@"yes, found a match");
                
                //CODE GOES HERE
            }
        }
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
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
