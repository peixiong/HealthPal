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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
