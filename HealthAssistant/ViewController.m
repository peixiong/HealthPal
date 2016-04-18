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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

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
    Firebase *ref = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    
    [facebookLogin logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            NSLog(@"Facebook login failed. Error: %@", error);
        } else if (result.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else {
            NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
            [ref authWithOAuthProvider:@"facebook" token:accessToken withCompletionBlock:^(NSError *error, FAuthData *authData) {
                if (error) {
                    NSLog(@"Login failed. %@", error);
                } else {
                    NSLog(@"Logged in! %@", authData);
                    NSLog(@"facebook usename = [%@]", authData.providerData[@"displayName"]);
                    NSLog(@"facebook login email = [%@]", authData.providerData[@"email"]);
                    NSString *url = authData.providerData[@"profileImageURL"];
                    NSLog(@"facebook profile image url = [%@]", url);
                    UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]]];
                    self.testImageView.image = image;
                }
            }];
        }
    }];
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
