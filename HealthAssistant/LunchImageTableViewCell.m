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
    [self.pickerView selectRow:2 inComponent:0 animated:YES];
}

- (IBAction)onSelectPhotoButtonPressed:(UISegmentedControl *)sender{
    [self.delegate imageDidChangedWithCell:self andSegmentControl:sender];
}



@end
