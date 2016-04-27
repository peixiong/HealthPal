//
//  ProfileViewController.m
//  
//
//  Created by Pei Xiong on 4/18/16.
//
//

#import "ProfileViewController.h"
#import "GoalTableViewCell.h"
#import "ProfileInfoTableViewCell.h"
#import "FirebaseManager.h"


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Firebase *ref = [[Firebase alloc] initWithUrl: @"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts"];
    //NSString * uid = @"";
    
    
    
    [self.view endEditing:YES];
    
    
    self.goalNames = @[@"Carbohydrate",@"Protein", @"Calcium",@"Iron", @"Vitamin A",@"Vitamin C"];
    
    self.suggestedValueFemale19to50Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];
    
    self.suggestedValueMale1930Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];
    self.suggestedValueMale3150Age = @[@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0){
        
        if(indexPath.row == 0){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Name";
            cell.profileInfoTextField.placeholder = @"i.e. David Applseed";
            return cell;
        }if(indexPath.row == 1){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Date of Birth";
            cell.profileInfoTextField.placeholder = @"i.e 01/01/2001";
            return cell;
        }if(indexPath.row == 2){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Height";
            cell.profileInfoTextField.placeholder = @"i.e. 5\" 5'";
            return cell;
        }if(indexPath.row == 3){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Weight";
            cell.profileInfoTextField.placeholder = @"i.e. 150 lb";
            return cell;
        }if(indexPath.row == 4){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Gender";
            cell.profileInfoTextField.placeholder = @"i.e. Male";
            return cell;
        }else{
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"";
            cell.profileInfoTextField.text = @"";
            return cell;
        }

    }else{
        GoalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goal"];
        
        cell.goalLabel.text = self.goalNames[indexPath.row];
        cell.suggestedValueLabel.text = self.suggestedValueFemale19to50Age[indexPath.row];
        if (indexPath.row %2 == 0) {
            cell.backgroundColor = [UIColor lightGrayColor];
            return cell;
        }
        else{
            cell.backgroundColor = [UIColor whiteColor];
            return cell;
        }
        
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

