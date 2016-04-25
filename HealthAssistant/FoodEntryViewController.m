//
//  FoodEntryViewController.m
//  
//
//  Created by Pei Xiong on 4/19/16.
//
//

#import "FoodEntryViewController.h"
#import "ManualEntryFoodTableViewController.h"
@interface FoodEntryViewController ()

@property (nonatomic, strong) UISearchController *searchController;


@end

@implementation FoodEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ManualEntryFoodTableViewController *dvc = segue.destinationViewController;
    dvc.user = self.user;
}

@end
