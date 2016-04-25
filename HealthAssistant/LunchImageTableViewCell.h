//
//  LunchImageTableViewCell.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/24/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LunchImageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property UIImage *foodImage;
@end
