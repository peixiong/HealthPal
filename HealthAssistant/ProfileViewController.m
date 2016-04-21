//
//  ProfileViewController.m
//  
//
//  Created by Pei Xiong on 4/18/16.
//
//

#import "ProfileViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personalInfoTableView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];


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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textLabel.text = @"Put goals over here";
        return cell;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        if (section == 0){
            return 5;
        }else{
            return 1;
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



@end

