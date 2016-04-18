//
//  RegisterViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/17/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "RegisterViewController.h"
#import <Firebase/Firebase.h>

@interface RegisterViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

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
    self.imageView.layer.cornerRadius = 50;
}

- (IBAction)onSignUpButtonPressed:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *emailAddress = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmedPassword = self.confirmPasswordTextField.text;
    NSString *alertMessage;
    
    if (username.length == 0 || emailAddress.length == 0 || password.length == 0 || confirmedPassword.length == 0) {
        alertMessage = @"One of the required fields is empty";
    } else if (![password isEqualToString:confirmedPassword]) {
        alertMessage = @"Password are different";
    }
    
    if (alertMessage != nil) {
        [self showAlertWithMessage:alertMessage];
    } else {
        [self createNewUser];
    }
}

-(void)createNewUser{
    NSString *username = self.usernameTextField.text;
    NSString *emailAddress = self.emailAddressTextField.text;
    NSString *password = self.passwordTextField.text;
    
    // Create a reference to a Firebase database URL
    Firebase *myRootRef = [[Firebase alloc] initWithUrl:@"https://blinding-heat-8730.firebaseio.com"];
    [myRootRef createUser:emailAddress password:password withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
        if (error) {
            NSLog(@"There was an error creating the account, error: %@", error.localizedDescription);
            [self showAlertWithMessage:error.localizedDescription];
        } else {
            //get data from firebase
            NSString *uid = [result objectForKey:@"uid"];
            NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
            NSString *imageStr = [imageData base64EncodedStringWithOptions:0];
            NSLog(@"Successfully created user account with uid: %@", uid);
            
            //generate user dictionary
            NSDictionary *user = @{
                                   @"username" : username,
                                   @"email" : emailAddress,
                                   @"image" : imageStr
                                   };
            NSString *path = [NSString stringWithFormat:@"users/%@", uid];
            Firebase *userRef = [myRootRef childByAppendingPath: path];
            [userRef setValue:user];
        }
    }];
}

-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
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
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //compress image size
    CGSize newSize = CGSizeMake(250.0f, 250.0f);
    UIGraphicsBeginImageContext(newSize);
    [editedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.imageView.image = newImage;
    [self dismissViewControllerAnimated:picker completion:nil];
}


@end
