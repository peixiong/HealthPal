//
//  SelectedFoodPropertyCell.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/23/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "SelectedFoodPropertyCell.h"

@implementation SelectedFoodPropertyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.text = self.target.name;
    self.checkLabel.text = self.target.selected;
    self.suggestedLabel.text = [NSString stringWithFormat:@"%i %@", self.target.suggested, self.target.unit];
    int targetValue = (int)([self.slider value]*self.target.suggested);
    self.targetLabel.text = [NSString stringWithFormat:@"%i %@", targetValue, self.target.unit];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
