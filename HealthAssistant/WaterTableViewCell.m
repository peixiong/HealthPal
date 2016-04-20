//
//  WaterTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "WaterTableViewCell.h"

@implementation WaterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label.text = @"Water";

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
