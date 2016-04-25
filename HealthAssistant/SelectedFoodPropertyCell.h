//
//  SelectedFoodPropertyCell.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/23/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectedNutritionTarget.h"
@interface SelectedFoodPropertyCell : UITableViewCell
@property SelectedNutritionTarget *target;
@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *suggestedLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end
