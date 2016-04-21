//
//  NutritionsTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleChartView.h"
#import "NCIZoomGraphView.h"
#import "NCIAxis.h"


@interface NutritionsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *label;

//Chart
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property NCISimpleChartView *chart;

//Collection View
@property (weak, nonatomic) IBOutlet UICollectionView *nutritionsButtonView;
@property NSArray *nutritionsArray;





@end
