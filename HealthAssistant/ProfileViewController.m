//
//  ProfileViewController.m
//  
//
//  Created by Pei Xiong on 4/18/16.
//
//

#import "ProfileViewController.h"
#import "GoalTableViewCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self.view endEditing:YES];
    
    
    self.goalNames = @[@"Carbohydrate",@"Protein", @"Calcium",@"Iron", @"Vitamin A",@"Vitamin C"];
    
    self.suggestedValueFemale19to50Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];
    
    self.suggestedValueMale1930Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];
    self.suggestedValueMale3150Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0){
        
    
        if(indexPath.row == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Name"];
        return cell;
        }
        
        
        if (indexPath.row == 1){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Date of Birth"];
            return cell;
        }
        
        
        if (indexPath.row == 2){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Height"];
            return cell;
        }
        
        
        if (indexPath.row == 3){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Weight"];
            return cell;
        }
        
        
        else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Gender"];
            return cell;
        }

    }else{
        GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goal"];
        
        cell.goalLabel.text = self.goalNames[indexPath.row];
        cell.suggestedValueLabel.text = self.suggestedValueFemale19to50Age[indexPath.row];
        if (indexPath.row %2 == 0) {
            cell.backgroundColor = [UIColor lightGrayColor];
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
        }
            return cell;
        }
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0){
            return 5;
        }else{
            return self.goalNames.count;
        }
}

// 1st section for Profile
// 2nd section for Goals
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"Profile Information", @"Profile Information");
            break;
        case 1:
            sectionName = NSLocalizedString(@"Goals", @"Goals");
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}



-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section)
    
    {
        case 0:
            return 40.0f;
        case 1:
            return 110.0f;
    }
    return 0.0f;
}




@end

