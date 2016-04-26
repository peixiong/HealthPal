//
//  GoalTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/25/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "GoalTableViewCell.h"

@implementation GoalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.valueSlider.minimumValue = 10;
    self.valueSlider.maximumValue = 600;
    self.valueSlider.value = [self.actualValueLabel.text floatValue];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)sliderValueChanged:(id)sender {
    self.actualValueLabel.text = [NSString stringWithFormat:@"%.1f", self.valueSlider.value];
    
}


@end
