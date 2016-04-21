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
    
    self.nutritionsArray = [NSArray arrayWithObjects:@"Calories", @"sugar", @"Vitamin A", nil];

    
    self.label.text = @"Nutritions";
    
    
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


#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.nutritionsArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"NutritionCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    

    
    int cellX = cell.frame.origin.x;
    int cellY = cell.frame.origin.y;

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cellX, cellY, 100, 40)];
    label.text = [self.nutritionsArray objectAtIndex:indexPath.row];
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor grayColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.nutritionsButtonView addSubview:label];

    return cell;
}





- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//        self.minimumLineSpacing = 1.0;
//        self.minimumInteritemSpacing = 1.0;
//        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return CGSizeMake(160, 40);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
}



@end
