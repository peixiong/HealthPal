//
//  NutritionsTableViewCell.h
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
#import "NutritionCategory.h"
#import "FirebaseManager.h"
#import "User.h"



@interface NutritionsTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BEMSimpleLineGraphDelegate, BEMSimpleLineGraphDataSource, FirebaseManagerDelegate>

// Title
@property (weak, nonatomic) IBOutlet UILabel *label;

// Chart
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

@property UILabel *buttonLabel;

// Collection View (buttons)

@property (weak, nonatomic) IBOutlet UICollectionView *nutritionsButtonView;
@property NSArray *nutritionsArray;


@property User *user;
@property Food *food;




@property NSMutableArray *foodIDs;
@property NSMutableArray *dataForAllDays;


@property NutritionCategory *calories;
@property NutritionCategory *carbs;
@property NutritionCategory *sodium;
@property NutritionCategory *calcium;
@property NutritionCategory *protien;
@property NutritionCategory *fiber;
@property NutritionCategory *fat;
@property NutritionCategory *iron;
@property NutritionCategory *sugar;
@property NutritionCategory *vitA;
@property NutritionCategory *vitC;


//-(instancetype)initWithStyle:(UITableViewCellStyle)style
//             reuseIdentifier:(NSString *)reuseIdentifier
//                        user:(User *)user;

-(void)loadCell;

@end
