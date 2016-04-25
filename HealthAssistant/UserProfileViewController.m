//
//  UserProfileViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/23/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "UserProfileViewController.h"
@interface UserProfileViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.user.selectedFoodProperties = @[@0,@1,@2,@3,@4];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCellID"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
@end
