//
//  NutritionsTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "NutritionsTableViewCell.h"

@implementation NutritionsTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.label.text = @"Nutritions";
    //[self.label setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
