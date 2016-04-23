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
    self.chart = [[NCISimpleChartView alloc]initWithFrame:
                  CGRectMake(-20, -30, self.frame.size.width*0.95, self.frame.size.height/2) andOptions: @{
                                                                                                      
                                                                                                      nciShowPoints : @YES,
                                                                                                      nciUseDateFormatter: @YES,//nciXLabelRenderer
                                                                                                      nciXAxis: @{nciLineColor: [UIColor blackColor],
                                                                                                                  nciLineDashes: @[],
                                                                                                                  nciLineWidth: @2,
                                                                                                                  nciLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                                                                                                  nciLabelsColor: [UIColor blackColor],
                                                                                                                  nciLabelsDistance: @120,
                                                                                                                  nciUseDateFormatter: @YES
                                                                                                                  },
                                                                                                      nciYAxis: @{nciLineColor: [UIColor blackColor],
                                                                                                                  nciLineDashes: @[@2,@2],
                                                                                                                  nciLineWidth: @1,
                                                                                                                  nciLabelsFont: [UIFont fontWithName:@"MarkerFelt-Thin" size:12],
                                                                                                                  nciLabelsColor: [UIColor blackColor],
                                                                                                                  nciLabelsDistance: @30,
                                                                                                                  //nciLabelRenderer: ^(double value)
                                                                                                                  },
                                                                                                      
                                                                                                      }];
    int numOfPoints = 10;
    for (int ind = 0; ind < numOfPoints; ind ++){
        [self.chart addPoint:ind val:@[@(arc4random() % 5)]];
        
    }
    
    
    [self.chartView addSubview:self.chart];
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
