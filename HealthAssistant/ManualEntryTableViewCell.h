//
//  ManualEntryTableViewCell.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ManualEntryTableViewCell;

@protocol ManualEntryTableViewCellDelegate <NSObject>
@optional
-(void)textFieldDidChangedWithCell:(ManualEntryTableViewCell *)cell;
@end

@interface ManualEntryTableViewCell : UITableViewCell
@property id<ManualEntryTableViewCellDelegate> delegate;
@property UITextField *textField;
@property UILabel *typeLabel;
@end
