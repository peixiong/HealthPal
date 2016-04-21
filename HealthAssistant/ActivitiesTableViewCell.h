//
//  ActivitiesTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCISimpleChartView.h"
#import "NCIZoomGraphView.h"
#import "NCIAxis.h"

@interface ActivitiesTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *label;

// Collection View
@property (weak, nonatomic) IBOutlet UICollectionView *buttonsBar;
@property NSArray *activitiesArray;

//Chart
@property (weak, nonatomic) IBOutlet UIView *chartView;
@property NCISimpleChartView *chart;


@end
