//
//  NutritionsTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "NutritionsTableViewCell.h"

@implementation NutritionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //Setting up delegates for collection view
    self.nutritionsButtonView.delegate = self;
    self.nutritionsButtonView.dataSource = self;
    
    self.nutritionsArray = [NSArray arrayWithObjects:@"Calories",@"Carbs",@"Protein",@"Fat",@"Sugar",@"Total Fiber", @"Sodium",@"Calcium",@"Iron", @"Vitamin A",@"Vitamin C", nil];

    
    self.label.text = @"Nutritions";
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 8.0;
    
    self.chartView.layer.masksToBounds = YES;
    self.chartView.layer.cornerRadius = 8.0;
    
    self.chart = [[NCISimpleChartView alloc]initWithFrame:
                  CGRectMake(-20, -20, self.frame.size.width-30, self.frame.size.height/2) andOptions: @{
                                                            
                                                            nciLabelsDistance: @5,
                                                            
                                                            nciShowPoints : @YES,
                
                                                            nciXAxis: @{nciLineColor: [UIColor blackColor],
                                                                        nciLineDashes: @[],
                                                                        nciLineWidth: @1,
                                                                        nciLabelsFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12],
                                                                        nciLabelsColor: [UIColor blackColor],
                                                                        nciLabelsDistance: @50,
                                                                        },
                                                            
                                                            nciYAxis: @{nciLineColor: [UIColor blackColor],
                                                                        nciLineDashes: @[@2,@2],
                                                                        nciLineWidth: @1,
                                                                        nciLabelsFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12],
                                                                        nciLabelsColor: [UIColor blackColor],
                                                                        nciLabelsDistance: @30,
                                                                        //nciLabelRenderer: ^(double value)
                                                                        },
                                                            
                                                            nciIsFill: @[@(NO), @(NO)],
                                                            nciIsSmooth: @[@(NO), @(YES)],
                                                            nciLineColors: @[[UIColor orangeColor], [NSNull null]],
                                                            nciLineWidths: @[@2, [NSNull null]],
                                                            nciHasSelection: @YES,
                                                            nciSelPointColors: @[[UIColor blueColor]],
                                                            nciSelPointImages: @[[NSNull null], @"star"],
                                                            
                                                            
                                                            
                                                            }];
    
    // Values of numbers to plotted on graph
    NSArray *points = @[@4.0, @5.0, @2.0, @5.0, @2.0, @9.0, @3.0];
    for (int i = 0; i < points.count; i ++){
        [self.chart addPoint:i val:@[points[i]]];
    }
    
    
    [self.chartView addSubview:self.chart];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nutritionsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"NutritionCell";
    
    // Initing a cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    // Initing a label for each cell
    int cellX = cell.frame.origin.x;
    int cellY = cell.frame.origin.y;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cellX, cellY, 100, 40)];
    label.text = [self.nutritionsArray objectAtIndex:indexPath.row];
    label.clipsToBounds = YES;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nutritionsButtonView addSubview:label];

    return cell;
}


// size of each cell in the UICollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(95, 40);
}


// Action on cell pressed
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}



@end
