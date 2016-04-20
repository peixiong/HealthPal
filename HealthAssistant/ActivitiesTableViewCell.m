//
//  ActivitiesTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ActivitiesTableViewCell.h"

@implementation ActivitiesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.text = @"Activities";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
