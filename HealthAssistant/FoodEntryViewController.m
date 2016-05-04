//
//  FoodEntryViewController.m
//  
//
//  Created by Pei Xiong on 4/19/16.
//
//

#import "FoodEntryViewController.h"
#import "ManualEntryFoodTableViewController.h"
#import "Food.h"

@interface FoodEntryViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray<NSDictionary *> *foodInfoFromJason;
@property NSMutableArray<Food *> *foodsResults;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *recentFoodButton;

@end

@implementation FoodEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.recentFoodButton.layer.borderWidth = 10;
    self.recentFoodButton.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    [self loadJasonWithString: @"chicken noodle"];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",self.searchBar.text);
    self.foodsResults = [NSMutableArray new];
    NSString *modifiedSearchText = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *searchStr = [NSString stringWithFormat:@"https://api.nutritionix.com/v1_1/search/%@?results=0:20&fields=item_name,brand_name,upc,nf_calories,nf_total_fat,nf_sodium,nf_total_carbohydrate,nf_dietary_fiber,nf_sugars,nf_protein,nf_vitamin_a_dv,nf_vitamin_c_dv,nf_calcium_dv,nf_iron_dv,nf_serving_per_container,nf_serving_size_qty,nf_serving_size_unit,nf_serving_weight_grams&appId=97e51eca&appKey=35feb79df2ec3bba88960183e4a929bc", modifiedSearchText];
    [self loadJasonWithString:searchStr];
    [self.searchBar resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCellID"];
    cell.textLabel.text = self.foodsResults[indexPath.row].foodProperties[1].value;
    cell.detailTextLabel.text = self.foodsResults[indexPath.row].foodProperties[3].value;
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.foodsResults.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ManualEntryFoodTableViewController *vc = [[UIStoryboard storyboardWithName:@"ManualEntry" bundle:nil] instantiateViewControllerWithIdentifier:@"manualEntry"];
    vc.food = self.foodsResults[indexPath.row];
    vc.user = self.user;
    [self.navigationController pushViewController:vc animated:true];
}

-(void)loadJasonWithString:(NSString *)str{
    NSURL *url = [NSURL URLWithString:str];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        self.foodInfoFromJason = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError][@"hits"];
        if (jsonError) {
            NSLog(@"there is an error loading Json data");
        }
        NSLog(@"there are %lu objected loaded from json",(unsigned long)self.foodInfoFromJason.count);
        NSLog(@"%@",self.foodInfoFromJason.description);
        
        for (NSDictionary *dict in self.foodInfoFromJason) {
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
            [self.foodsResults addObject:food];
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [task resume];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.searchBar resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ManualEntryFoodTableViewController *dvc = segue.destinationViewController;
    dvc.user = self.user;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

@end
