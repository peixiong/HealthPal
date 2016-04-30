//
//  AddWaterViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/28/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "AddWaterViewController.h"
#import "AppDelegate.h"

@interface AddWaterViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIImageView *piggyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *waterImageView;
@property NSMutableArray *containers;
@property NSManagedObjectContext *moc;

@end

@implementation AddWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    [self loadCoreData];
    if (self.containers.count == 0) {
        [self populateWithDefaultContainers];
    }
}
- (IBAction)onAddWaterButtonPressed:(UIButton *)sender {
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

}


-(void)populateWithDefaultContainers{
    NSArray *containerImages = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"container2oz"],[UIImage imageNamed:@"container4oz"],[UIImage imageNamed:@"container8oz"], nil];
    NSArray *containerSizes = [[NSArray alloc]initWithObjects:@"2",@"4",@"8", nil];
    for (int i =0; i<containerSizes.count; i++) {
        WaterContainer *waterContainer = [WaterContainer new];
        waterContainer.containerImageDaTa = UIImagePNGRepresentation(containerImages[i]);
        waterContainer.size = containerSizes[i];
        [self.containers addObject:waterContainer];
    }
    
    [self saveToCoreData];
}

//load data from coredata
-(void)loadCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WaterContainer"];
    NSError *error;
    NSArray *temp = [self.moc executeFetchRequest:request error:&error];
    if (error == nil) {
        NSLog(@"Loading no problem");
    } else {
        NSLog(@"Error is %@", error);
    }
    NSLog(@"loaded people count = [%ld]", temp.count);
    self.containers = [temp mutableCopy];
}

-(void)saveToCoreData{
    // save to moc
    NSError *error;
    if ([self.moc save:&error]) {
        NSLog(@"Saved to coredata");
    } else {
        NSLog(@"\nWOOOOOPS!!!!\n");
    }
}

@end
