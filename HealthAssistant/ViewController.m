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
@property (weak, nonatomic) IBOutlet UIImageView *testImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateImagearrayAndIntroductionStr];
    [self addIndicatorsToSubview];
}

-(void)populateImagearrayAndIntroductionStr{
    self.imagearray = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        [self.imagearray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i",i]]];
    }
    self.introductionsStr = @[@"record your daily nutritions",@"give suggestions for your next meal or shopping plan",@"creat your shoppinglist",@"compete your record with your friends"];
}

-(void)addIndicatorsToSubview{
    self.indicators = [NSMutableArray new];
    for (int i = 0; i<4; i++) {
        UIImageView *fork =[[UIImageView alloc] initWithFrame:CGRectMake(145 + i*23,486,10,10)];
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
