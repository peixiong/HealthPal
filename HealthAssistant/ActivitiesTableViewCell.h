//
//  ActivitiesTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"


@interface ActivitiesTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

@property (weak, nonatomic) IBOutlet UILabel *label;

// Collection View
@property (weak, nonatomic) IBOutlet UICollectionView *buttonsBar;
@property NSArray *activitiesArray;

//Chart
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@property (weak, nonatomic) IBOutlet UILabel *labelValues;
@property (weak, nonatomic) IBOutlet UIStepper *graphObjectIncrement;
@property BEMSimpleLineGraphView *myGraph;
@property int previousStepperValue;
@property int totalNumber;
- (IBAction)addOrRemovePointFromGraph:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *labelDates;

@property NSArray *points;
@property NSArray *dates;

@end
