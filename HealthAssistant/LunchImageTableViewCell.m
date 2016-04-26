//
//  LunchImageTableViewCell.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/24/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "LunchImageTableViewCell.h"

@implementation LunchImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.segmentedControl setSelectedSegmentIndex:UISegmentedControlNoSegment];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)onSelectPhotoButtonPressed:(UISegmentedControl *)sender{
    [self.delegate imageDidChangedWithCell:self andSegmentControl:sender];
}
@end
