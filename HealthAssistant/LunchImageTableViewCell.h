//
//  LunchImageTableViewCell.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/24/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LunchImageTableViewCell;

@protocol LunchImageTableViewCellDelegate
@optional
-(void)imageDidChangedWithCell:(LunchImageTableViewCell *)cell andSegmentControl:(UISegmentedControl *)segmentControl;

@end


@interface LunchImageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *foodImageView;
@property id<LunchImageTableViewCellDelegate> delegate;
- (IBAction)onSelectPhotoButtonPressed:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;

@end
