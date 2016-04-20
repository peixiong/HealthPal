//
//  WaterTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *chartView;

@end
