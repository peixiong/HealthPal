//
//  ManualEntryTableViewCell.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "ManualEntryTableViewCell.h"
@interface ManualEntryTableViewCell() <UITextFieldDelegate>
@end


@implementation ManualEntryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.05*sizeOfScreen.width, 0.1*self.frame.size.height, 0.4375*sizeOfScreen.width, 0.8*self.frame.size.height)];
    [self addSubview:self.typeLabel];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0.5*sizeOfScreen.width, 0.1*self.frame.size.height, 0.45*sizeOfScreen.width, 0.8*self.frame.size.height)];
    self.textField.delegate = self;
    self.textField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.textField];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textFieldDidChangedWithCell:)]) {
        [self.delegate textFieldDidChangedWithCell:self];
    } else {
        NSLog(@"Self.delegate = nil or delegate does not have the (textFieldDidChangedWith) method");
    }
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(textFieldDidChangedWith:andCell:)]) {
//        [self.delegate textFieldDidChangedWith:string andCell:self];
//    } else {
//        NSLog(@"Self.delegate = nil or delegate does not have the (textFieldDidChangedWith) method");
//    }
//    return YES;
//}

@end
