//
//  NutritionsTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"


@interface NutritionsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource>

// Title
@property (weak, nonatomic) IBOutlet UILabel *label;

// Chart
@property (weak, nonatomic) IBOutlet UIView *graphView;
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



// Collection View (buttons)

@property (weak, nonatomic) IBOutlet UICollectionView *nutritionsButtonView;
@property NSArray *nutritionsArray;





@end
