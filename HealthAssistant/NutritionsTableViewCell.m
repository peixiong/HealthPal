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
    
    
    self.points = @[@34.1f,@25.1f,@38.1f,@24.1f,@42.f, @25.1f,@38.1f,@24.1f,@42.f];
    self.dates = @[@"2016-01-01 03:34:42 +0000", @"2016-01-02 03:34:42 +0000", @"2016-01-03 03:34:42 +0000", @"2016-01-04 03:34:42 +0000", @"2016-01-05 03:34:42 +0000", @"2016-01-06 03:34:42 +0000", @"2016-01-07 03:34:42 +0000", @"2016-01-08 03:34:42 +0000", @"2016-01-09 03:34:42 +0000"];
    
    
    [self cellTitle];
    [self hydrateDatasets];
    [self createGraph];
    [self.contentView addSubview:self.myGraph];
    [self graphProperties];
    [self drawAverageLine];
    [self graphLabels];
    [self gradientForGraphLine];
    
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
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(cellX, cellY, 100, 25)];
    label.text = [self.nutritionsArray objectAtIndex:indexPath.row];
    label.clipsToBounds = YES;
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.0;
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor greenColor].CGColor;
    label.textColor = [UIColor greenColor];
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


// Create & apply a gradient to apply to the bottom portion of the graph
-(void)gradientForGraphLine{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0};
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
}

// Setup the cell title
- (void) cellTitle{
    self.label.text = @"Activities";
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 8.0;
    self.label.layer.borderWidth = 1;
    self.label.layer.borderColor = [UIColor redColor].CGColor;
    self.label.textColor = [UIColor redColor];
}



// Draw an average line for values on the graph
- (void)drawAverageLine{
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor darkGrayColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
}



//Creating a graph
-(void)createGraph{
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(20, 110, self.frame.size.width-40, self.frame.size.height/2.5)];
    
    //[self.myGraph sizeToFit];
    //self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    
    self.myGraph.dataSource = self;
    self.myGraph.delegate = self;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.layer.masksToBounds = YES;
    self.myGraph.layer.cornerRadius = 8.0;
    self.myGraph.backgroundColor = [UIColor redColor];
    self.myGraph.colorTop = [UIColor redColor];
    self.myGraph.colorBottom = [UIColor redColor];
}



// Enable and disable various graph properties and axis displays
- (void)graphProperties{
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;
    // Set the graph's animation style to draw, fade, or none
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    // Show the y axis values with this format string
    self.myGraph.formatStringForValues = @"%.1f";
}


// Graph labels
-(void)graphLabels{
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = @"now and later";
}



//Pulling data for graph
- (void)hydrateDatasets {
    // Reset the arrays of values (Y-Axis points) and dates (X-Axis points / labels)
    if (!self.arrayOfValues) self.arrayOfValues = [[NSMutableArray alloc] init];
    if (!self.arrayOfDates) self.arrayOfDates = [[NSMutableArray alloc] init];
    [self.arrayOfValues removeAllObjects];
    [self.arrayOfDates removeAllObjects];
    
    self.previousStepperValue = self.graphObjectIncrement.value;
    self.totalNumber = 0;
    NSDate *baseDate = [NSDate date];
    BOOL showNullValue = true;
    
    // Add objects to the array based on the stepper value
    for (int i = 0; i < 9; i++) {
        //[self.arrayOfValues addObject:@([self getValues])]; // Get Floatvalues for the graph
        [self.arrayOfValues addObject:self.points[i]];
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
            //[self.arrayOfDates addObject:self.dates[i]]; // Dates for the X-Axis of the graph
            
        } else if (showNullValue && i == 4) {
            [self.arrayOfDates addObject:[self getDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
            //[self.arrayOfDates addObject:[self getDate:self.dates[i]]];
            
            
            
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            [self.arrayOfDates addObject:[self getDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
        }
        
        self.totalNumber = self.totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
}



//Getting one more day on pressing (+)
- (NSDate *)getDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}


// Returns the dates on label
- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSDate *date = self.arrayOfDates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}



//Not being used now "It used to generate random numbers for graph"
- (float)getValues {
    float i1 = (float)(arc4random() % 5) / 100 ;
    NSLog(@"%f",i1);
    return i1;
}



- (IBAction)addOrRemovePointFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > _previousStepperValue) {
        // Add point
        NSLog(@" + pressed");
        [self.arrayOfValues addObject:@([self getValues])];
        NSDate *newDate = [self getDate:(NSDate *)[self.arrayOfDates lastObject]];
        [self.arrayOfDates addObject:newDate];
        [self.myGraph reloadGraph];
    } else if (self.graphObjectIncrement.value < self.previousStepperValue) {
        // Remove point
        NSLog(@" + pressed");
        [self.arrayOfValues removeObjectAtIndex:0];
        [self.arrayOfDates removeObjectAtIndex:0];
        [self.myGraph reloadGraph];
    }
    
    self.previousStepperValue = self.graphObjectIncrement.value;
}




#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}


// On touching the graph, below things should happen to the chart
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelValues.text = [NSString stringWithFormat:@"%@", [self.arrayOfValues objectAtIndex:index]];
    self.labelDates.text = [NSString stringWithFormat:@"%@", [self labelForDateAtIndex:index]];
}



// On touching the graph, other things should happen (NOT to the chart)

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelValues.alpha = 0.0;
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
        self.labelDates.text = [NSString stringWithFormat:@"%@ - %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelValues.alpha = 1.0;
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}


//////////////////////// HAS TO BE DINAMIC

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
    self.labelValues.text = [NSString stringWithFormat:@"%i mg", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = [NSString stringWithFormat:@"%@ - %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
}




/* - (void)lineGraphDidFinishDrawing:(BEMSimpleLineGraphView *)graph {
 // Use this method for tasks after the graph has finished drawing
 } */

- (NSString *)popUpSuffixForlineGraph:(BEMSimpleLineGraphView *)graph {
    //NSString *string = [NSString stringWithFormat:@"%@ mg", [self.labelValues.text]];
    //return @" mg";
    return [NSString stringWithFormat:@"%i mg", [[self.myGraph calculatePointValueSum] intValue]];
}

//- (NSString *)popUpPrefixForlineGraph:(BEMSimpleLineGraphView *)graph {
//    return @"$ ";
//}

#pragma mark - Optional Datasource Customizations
/*
 This section holds a bunch of graph customizations that can be made.  They are commented out because they aren't required.  If you choose to uncomment some, they will override some of the other delegate and datasource methods above.
 
 */

- (NSInteger)baseIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

//- (NSInteger)incrementIndexForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
//    return 2;
//}

//- (NSArray *)incrementPositionsForXAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
//    NSMutableArray *positions = [NSMutableArray array];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSInteger previousDay = -1;
//    for(int i = 0; i < self.arrayOfDates.count; i++) {
//        NSDate *date = self.arrayOfDates[i];
//        NSDateComponents * components = [calendar components:NSCalendarUnitDay fromDate:date];
//        NSInteger day = components.day;
//        if(day != previousDay) {
//            [positions addObject:@(i)];
//            previousDay = day;
//        }
//    }
//    return positions;
//
//}
//
//- (CGFloat)baseValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
//    NSNumber *minValue = [graph calculateMinimumPointValue];
//    //Let's round our value down to the nearest 100
//    double min = minValue.doubleValue;
//    double roundPrecision = 100;
//    double offset = roundPrecision / 2;
//    double roundedVal = round((min - offset) / roundPrecision) * roundPrecision;
//    return roundedVal;
//}

- (CGFloat)incrementValueForYAxisOnLineGraph:(BEMSimpleLineGraphView *)graph {
    NSNumber *minValue = [graph calculateMinimumPointValue];
    NSNumber *maxValue = [graph calculateMaximumPointValue];
    double range = maxValue.doubleValue - minValue.doubleValue;
    float increment = 1.0;
    if (range <  10) {
        increment = 2;
    } else if (range < 100) {
        increment = 10;
    } else if (range < 500) {
        increment = 50;
    } else if (range < 1000) {
        increment = 100;
    } else if (range < 5000) {
        increment = 500;
    } else {
        increment = 1000;
    }
    return increment;
}





@end
