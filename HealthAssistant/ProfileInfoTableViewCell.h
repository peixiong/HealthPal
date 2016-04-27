//
//  ProfileInfoTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/26/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profileInfoLabel;
@property (weak, nonatomic) IBOutlet UITextField *profileInfoTextField;

@end
