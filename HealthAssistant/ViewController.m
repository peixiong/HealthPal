//
//  ViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/16/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ViewController.h"
#import "WelcomeCollectionViewCell.h"
#import <Firebase/Firebase.h>
#import "FirebaseManager.h"
#import "TabbarViewController.h"
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FirebaseManagerDelegate>

@property NSMutableArray<UIImage *> *imagearray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray<NSString *> *introductionsStr;
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;
@property NSMutableArray<UIImageView *> *indicators;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateImagearrayAndIntroductionStr];
    [self addIndicatorsToSubview];
    [FirebaseManager sharedInstance].delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userId"];
    if(userId){
        // Mark as already launched before:
        [[FirebaseManager sharedInstance] retrieveUserDataWithUid:userId];
        self.loginButton.enabled = true;
        self.signUpButton.enabled = true;
        self.facebookLoginButton.enabled = true;
    } else {
        //do nothing
    }
}

-(void)populateImagearrayAndIntroductionStr{
    self.imagearray = [NSMutableArray new];
    for (int i = 1; i<5; i++) {
        [self.imagearray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i",i]]];
    }
    self.introductionsStr = @[@"Record your daily nutritions intakes, and put them on chart for your better reference.", @"Based on your personal infomation, calculate the USDA suggested average nutrition requirement.", @"Give numourous suggestions for your next meal or shopping plan based on your concern.", @"Record your daily water intakes and try to feed your health-piggy bank each day:)"];
}

-(void)addIndicatorsToSubview{
    self.indicators = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        UIImageView *fork =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 -41 + 24*i,486,10,10)];
        fork.backgroundColor = [UIColor grayColor];
        fork.layer.cornerRadius= 5;
        fork.image=[UIImage imageNamed:@"fork"];
        fork.tag = i;
        [self.indicators addObject:fork];
        [self.view addSubview:fork];
    }
}

//facebook login
- (IBAction)onFacebookLoginPressed:(UIButton *)sender {
    [FirebaseManager sharedInstance].delegate = self;
    [[FirebaseManager sharedInstance] facebookLogin];
}

-(void)didLoginWithUser:(User *)user{
    TabbarViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"mainTabbar"];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:true];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults objectForKey:@"userId"];
    if (!userId) {
        [defaults setObject:user.uid forKey:@"userId"];
        [defaults synchronize];
    }

}


//MARK..programma for collection view
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WelcomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellID" forIndexPath:indexPath];
    
    cell.imageView.image = self.imagearray[indexPath.row];
    self.introductionLabel.text = self.introductionsStr[indexPath.row];
    UIImageView *fork = self.indicators[indexPath.row];
    
    for (fork in self.indicators) {
        if (fork.tag == indexPath.row) {
            fork.layer.backgroundColor = [[UIColor whiteColor] CGColor];
        } else {
            fork.layer.backgroundColor = [[UIColor grayColor] CGColor];
        }
    }
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagearray.count;
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    return size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}


-(IBAction)unwindSegue:(UIStoryboardSegue *)sender {
    
}

@end
