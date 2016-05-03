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
#import "LogOutTableViewCell.h"


@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, FirebaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;



@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profileImage.layer.cornerRadius = 12;
    self.profileImage.layer.masksToBounds = YES;
    
    [FirebaseManager sharedInstance].delegate = self;
    self.profileImage.image = self.user.image;
    NSLog(@"ChartsVC, this is the user being passed: %@",self.user.uid);
    NSLog(@"ChartsVC, this is the user's food: %@",self.user.timeFood);
    
    //Firebase *ref = [[Firebase alloc] initWithUrl: @"https://docs-examples.firebaseio.com/web/saving-data/fireblog/posts"];
    //NSString * uid = @"";
    
    
    
    [self.view endEditing:YES];
    
    
    self.goalNames = @[@"Calories", @"Carbohydrate",@"Protein", @"Calcium",
                       @"Iron", @"Vitamin A",@"Vitamin C", @"Sugar",
                       @"Total Fiber", @"Sodium", @"Water", @"Steps" ];
    
    self.suggestedValueFemale19to50Age = @[@"avg 2000", @"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d", @"30 g", @"26 g/d", @"<500mg", @">2 Liters", @"10,000"];
    
    self.suggestedValueMale1930Age = @[@"",@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];
    self.suggestedValueMale3150Age = @[@"",@"100 g/d", @"0.66 g/kg/d", @"800 mg/d", @"8.1 mg/d", @"500 (μg/d)a", @"60 mg/d"];

}

- (IBAction)onLogoutButtonPressed:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userId"];
    [defaults synchronize];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0){
        
        if(indexPath.row == 0){
            ProfileInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.profileInfoLabel.text = @"Name";
            cell.profileInfoTextField.text = self.user.username;
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

    }
    if (indexPath.section == 1){
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
    else{
        LogOutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logout"];
        
        return cell;
        }

    return nil;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0){
            return 5;
        }if (section == 1){
            return self.goalNames.count;
        }if (section == 2){
            return 1;
        }else{
            return 0;
        }
}

// Profile, Goals & Logout
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
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
        case 2:
            sectionName = NSLocalizedString(@"Logout", @"Logout");
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
            return 80.0f;
        case 2:
            return 80.0f;
    }
    return 0.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Goal has been selected" message:@"Alert message" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end

