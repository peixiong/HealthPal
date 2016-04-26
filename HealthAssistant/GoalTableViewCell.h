//
//  GoalTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/25/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UIButton *goalIsSelected;
@property (weak, nonatomic) IBOutlet UISlider *valueSlider;
@property (weak, nonatomic) IBOutlet UILabel *actualValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedValueLabel;

@end
