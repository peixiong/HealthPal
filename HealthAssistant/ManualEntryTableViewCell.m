//
//  ManualEntryTableViewCell.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ManualEntryTableViewCell.h"

@implementation ManualEntryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.025*self.frame.size.width, 0.1*self.frame.size.height, 0.5*self.frame.size.width, 0.8*self.frame.size.height)];
    [self addSubview:self.typeLabel];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0.6*self.frame.size.width, 0.1*self.frame.size.height, 0.375*self.frame.size.width, 0.8*self.frame.size.height)];
    self.textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textField];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
