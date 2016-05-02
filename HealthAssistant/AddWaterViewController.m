//
//  AddWaterViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/28/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "AddWaterViewController.h"
#import "AppDelegate.h"
#import "WaterSelectionCollectionViewCell.h"
#import "WaterSelectAddNewContainerCollectionViewCell.h"
#import "FirebaseManager.h"
#import <Firebase/Firebase.h>

@interface AddWaterViewController () <UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *piggyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *waterImageView;
@property NSMutableArray<WaterContainer *> *containers;
@property NSManagedObjectContext *moc;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *maxImageView;
@property (strong, nonatomic) IBOutlet UIButton *addbutton;
@property (strong, nonatomic) IBOutlet UILabel *currentLabel;
@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *word1Label;
@property (strong, nonatomic) IBOutlet UILabel *word2Label;
@property (strong, nonatomic) IBOutlet UIButton *minusButton;
@property (strong, nonatomic) IBOutlet UIButton *plusButton;
@property (strong, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UITextField *inputTextField;
@property (strong, nonatomic) IBOutlet UILabel *containerSizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ozLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property NSIndexPath *longPressIndexPath;

@property UIImage *containerImage;
@property int selectedRow;
@property NSInteger currentSize;
@property NSInteger goalSize;
@end

@implementation AddWaterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(![defaults objectForKey:@"LaunchedBeforeTrue"]){
        // Mark as already launched before:
        [defaults setObject:[NSDate date] forKey:@"LaunchedBeforeTrue"];
        [self populateWithDefaultContainers];
    } else {
        [self loadCoreData];
    }
    self.goalSize = [self.user.waterGoal integerValue];
    
    //check is there a entry for today
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyyMMdd"];
    [DateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dayStr = [DateFormatter stringFromDate:[NSDate date]];
    Firebase *waterRef = [[FirebaseManager sharedInstance] retrieveWaterRefForUser:self.user ForDate:dayStr];
    [waterRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        if (snapshot.value == [NSNull null]) {
            self.currentSize = 0;
            self.currentLabel.text = [NSString stringWithFormat:@"%li oz", self.currentSize];
            [self generateWaterViewWithHeight:0.7874*self.view.frame.size.height];
            [self.view sendSubviewToBack:self.waterImageView];
        } else{
            self.currentSize = [snapshot.value integerValue];
            self.currentLabel.text = [NSString stringWithFormat:@"%li oz", self.currentSize];
            [self generateWaterViewWithHeight:0.7874*self.view.frame.size.height - 0.2837*self.view.frame.size.height*self.currentSize/(float)self.goalSize];
            [self.view sendSubviewToBack:self.waterImageView];
        }
    }];
    
    self.maxImageView.hidden = true;
    self.addbutton.hidden = true;
    self.containerSizeLabel.hidden = true;
    self.photoLibraryButton.hidden = true;
    self.cameraButton.hidden = true;
    self.inputTextField.hidden =true;
    self.ozLabel.hidden = true;
    self.doneButton.hidden = true;
    self.cancelButton.hidden = true;
    self.goalLabel.text = [NSString stringWithFormat:@"%@ oz", self.user.waterGoal];
    

    //generate piggyImageView
    self.piggyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0.43*self.view.frame.size.height, self.view.frame.size.width, 0.57*self.view.frame.size.height)];
    self.piggyImageView.image = [UIImage imageNamed:@"piggy-bank-final"];
    [self.view addSubview:self.piggyImageView];
    [self.view bringSubviewToFront:self.currentLabel];
    [self.view bringSubviewToFront:self.word1Label];
    [self.view bringSubviewToFront:self.goalLabel];
    [self.view bringSubviewToFront:self.word2Label];
    [self.view bringSubviewToFront:self.minusButton];
    [self.view bringSubviewToFront:self.plusButton];
}

-(void)generateWaterViewWithHeight:(float)height{
    //generate waterImageView
    self.waterImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height)];
    self.waterImageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.waterImageView];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.containers.count) {
        WaterSelectAddNewContainerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addNewContainer" forIndexPath:indexPath];
        
        return cell;
    } else {
        WaterSelectionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"waterBottle" forIndexPath:indexPath];
        cell.waterBottleImage.image = [UIImage imageWithData:self.containers[indexPath.row].containerImageDaTa];
        cell.sizeLabel.text = [NSString stringWithFormat:@"%@ oz", self.containers[indexPath.row].size];
        return cell;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.containers.count + 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedRow = (int)indexPath.row;
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (indexPath.row < self.containers.count) {
        WaterSelectionCollectionViewCell *cellS = (WaterSelectionCollectionViewCell *)cell;
        self.maxImageView.image = cellS.waterBottleImage.image;
        self.maxImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.maxImageView.hidden = false;
        self.addbutton.hidden = false;
        self.containerSizeLabel.hidden = false;
        self.containerSizeLabel.text = cellS.sizeLabel.text;
    } else if (indexPath.row == self.containers.count) {
        self.maxImageView.hidden = false;
        self.maxImageView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        self.photoLibraryButton.hidden = false;
        self.cameraButton.hidden = false;
        self.inputTextField.hidden = false;
        self.ozLabel.hidden = false;
        self.doneButton.hidden = false;
        self.cancelButton.hidden = false;
    }
}

- (IBAction)onPhotoButtonPressed:(UIButton *)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = true;
    if (sender.tag == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:imagePicker animated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.containerImage = [info objectForKey:UIImagePickerControllerEditedImage];
    //self.maxImageView.image = image;

    

    [self dismissViewControllerAnimated:picker completion:nil];
}

- (IBAction)onDoneButtonPressed:(UIButton *)sender {
    WaterContainer *waterContainer = [NSEntityDescription insertNewObjectForEntityForName:@"WaterContainer" inManagedObjectContext:self.moc];
    waterContainer.containerImageDaTa = UIImagePNGRepresentation(self.containerImage);
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    waterContainer.size = [f numberFromString:self.inputTextField.text];
    [self.containers addObject:waterContainer];
    [self.collectionView reloadData];
    [self saveToCoreData];
    self.maxImageView.hidden = true;
    self.photoLibraryButton.hidden = true;
    self.cameraButton.hidden = true;
    self.ozLabel.hidden = true;
    self.doneButton.hidden = true;
    self.cancelButton.hidden = true;
    self.inputTextField.hidden = true;
    [self.view endEditing:YES];
    //self.maxImageView.image = nil;
}
- (IBAction)onCancelButtonPressed:(UIButton *)sender {
    self.maxImageView.hidden = true;
    self.photoLibraryButton.hidden = true;
    self.cameraButton.hidden = true;
    self.ozLabel.hidden = true;
    self.doneButton.hidden = true;
    self.cancelButton.hidden = true;
    self.inputTextField.hidden = true;
    [self.view endEditing:YES];
    //self.maxImageView.image = nil;
}

- (IBAction)onAddButtonPressed:(UIButton *)sender {
    self.maxImageView.hidden = true;
    self.maxImageView.image = nil;
    self.addbutton.hidden = true;
    self.containerSizeLabel.hidden = true;
    self.currentSize = self.currentSize + [self.containers[self.selectedRow].size integerValue];
    self.currentLabel.text = [NSString stringWithFormat:@"%li oz",self.currentSize];
    [[FirebaseManager sharedInstance] saveTimeWaterforUser:self.user andSize:[NSString stringWithFormat:@"%li",self.currentSize]];
    if (self.currentSize < self.goalSize) {
        float waterLevel = 0.2837*self.view.frame.size.height*self.currentSize/(float)self.goalSize;
        [UIView animateWithDuration:1 animations:^{
            self.waterImageView.center = CGPointMake(self.waterImageView.center.x, 1.2874*self.view.frame.size.height - waterLevel);
        } completion:nil];
    } else{
        [UIView animateWithDuration:1 animations:^{
            self.waterImageView.center = CGPointMake(self.waterImageView.center.x, 1.0037*self.view.frame.size.height);
        } completion:nil];
    }

}

- (IBAction)handleTap:(UITapGestureRecognizer *)sender {
    self.maxImageView.hidden = true;
    self.addbutton.hidden = true;
    self.containerSizeLabel.hidden = true;
    self.maxImageView.image = nil;
}

- (IBAction)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.longPressIndexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
        WaterSelectionCollectionViewCell *cell = (WaterSelectionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:self.longPressIndexPath];
        cell.deleteButton.hidden = false;
    }
}

- (IBAction)onDeleteButtonPressed:(UIButton *)sender {
    WaterContainer *waterContainer = [self.containers objectAtIndex:self.longPressIndexPath.row];
    [self.containers removeObject:waterContainer];
    [self.moc deleteObject:waterContainer];
    sender.hidden = true;
    [self.collectionView reloadData];
}

- (IBAction)onAddGoalButtonPressed:(UIButton *)sender {
    self.goalSize = self.goalSize + 2;
    self.goalLabel.text = [NSString stringWithFormat:@"%li oz", (long)self.goalSize];
    [[FirebaseManager sharedInstance] updateWaterGoalWith:(NSString *)self.user.uid andGoal:[NSString stringWithFormat:@"%li", self.goalSize]];
}
- (IBAction)onMinusGoalButtonPressed:(UIButton *)sender {
    self.goalSize = self.goalSize - 2;
    self.goalLabel.text = [NSString stringWithFormat:@"%li oz", (long)self.goalSize];
    [[FirebaseManager sharedInstance] updateWaterGoalWith:(NSString *)self.user.uid andGoal:[NSString stringWithFormat:@"%li", self.goalSize]];
}


-(void)populateWithDefaultContainers{
    self.containers = [NSMutableArray new];
    NSArray *containerImages = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"container2oz"],[UIImage imageNamed:@"container4oz"],[UIImage imageNamed:@"container8oz"], nil];
    NSArray *containerSizes = [[NSArray alloc] initWithObjects:@2,@4,@8, nil];
    for (int i =0; i<containerSizes.count; i++) {
        WaterContainer *waterContainer = [NSEntityDescription insertNewObjectForEntityForName:@"WaterContainer" inManagedObjectContext:self.moc];
        waterContainer.containerImageDaTa = UIImagePNGRepresentation(containerImages[i]);
        waterContainer.size = containerSizes[i];
        [self.containers addObject:waterContainer];
    }
    
    [self saveToCoreData];
}

//load data from coredata
-(void)loadCoreData{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"WaterContainer"];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"size" ascending:true];
    [request setSortDescriptors:[NSArray arrayWithObject:sort]];

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
