//
//  RegisterViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/17/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "RegisterViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseManager.h"
#import "TabbarViewController.h"
@interface RegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate,FirebaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    [self.segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width*0.1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [self.view addGestureRecognizer:tap];
}

-(void)handleTap{
    [self.view endEditing:true];
}

- (IBAction)onSignUpButtonPressed:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *emailAddress = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmedPassword = self.confirmPasswordTextField.text;
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    NSString *imageStr = [imageData base64EncodedStringWithOptions:0];
    [FirebaseManager sharedInstance].delegate = self;
    [[FirebaseManager sharedInstance] createNewUserWithUsername:username emailAddress:emailAddress password:password ConfirmedPassword:confirmedPassword andImageStr:imageStr];
}

-(void)didLoginWithUser:(User *)user {
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

//pick an image for user
- (IBAction)onSelectPhotoButtonPressed:(UISegmentedControl *)sender {
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = true;
    if (self.segmentControl.selectedSegmentIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        //[self presentViewController:imagePicker animated:true completion:nil];
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    }
    [self presentViewController:imagePicker animated:true completion:nil];
    [self.segmentControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //compress image size
    CGSize newSize = CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(newSize);
    [editedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
    [self dismissViewControllerAnimated:picker completion:nil];
}


@end
