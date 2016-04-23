//
//  WaterTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleChartView.h"
#import "NCIZoomGraphView.h"
#import "NCIAxis.h"

@interface WaterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property NCISimpleChartView *chart;

@end
