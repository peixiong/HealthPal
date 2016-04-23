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
    self.label.layer.masksToBounds = YES;
    self.label.layer.cornerRadius = 8.0;
    
    
    //Pulling data for graph
    [self hydrateDatasets];
    
    //Creating a graph
    BEMSimpleLineGraphView *myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(20, self.frame.size.height/3.8, self.frame.size.width-40, self.frame.size.height/2.5)];
    myGraph.dataSource = self;
    myGraph.delegate = self;
    myGraph.enablePopUpReport = YES;
    myGraph.layer.masksToBounds = YES;
    myGraph.layer.cornerRadius = 8.0;
    [self.contentView addSubview:myGraph];
    
    
    
    // Create & apply a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0};
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    
    // Enable and disable various graph properties and axis displays
    myGraph.enableTouchReport = YES;
    myGraph.enablePopUpReport = YES;
    myGraph.enableYAxisLabel = YES;
    myGraph.autoScaleYAxis = YES;
    myGraph.alwaysDisplayDots = NO;
    myGraph.enableReferenceXAxisLines = YES;
    myGraph.enableReferenceYAxisLines = YES;
    myGraph.enableReferenceAxisFrame = YES;
    
    // Draw an average line
    myGraph.averageLine.enableAverageLine = YES;
    myGraph.averageLine.alpha = 0.6;
    myGraph.averageLine.color = [UIColor darkGrayColor];
    myGraph.averageLine.width = 2.5;
    myGraph.averageLine.dashPattern = @[@(2),@(2)];
    
    // Set the graph's animation style to draw, fade, or none
    myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    myGraph.formatStringForValues = @"%.1f";
    
    // Setup initial curve selection segment
    //self.curveChoice.selectedSegmentIndex = self.myGraph.enableBezierCurve;

    // The labels to report the values of the graph when the user touches it
    self.labelValues.text = [NSString stringWithFormat:@"%i", [[self.myGraph calculatePointValueSum] intValue]];
    self.labelDates.text = @"now and later";

}


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
        [self.arrayOfValues addObject:@([self getValues])]; // Get Floatvalues for the graph
        if (i == 0) {
            [self.arrayOfDates addObject:baseDate]; // Dates for the X-Axis of the graph
        } else if (showNullValue && i == 4) {
            [self.arrayOfDates addObject:[self getDate:self.arrayOfDates[i-1]]]; // Dates for the X-Axis of the graph
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




- (float)getValues {
    float i1 = (float)(arc4random() % 5) / 100 ;
    NSLog(@"%float",i1);
    return i1;
}

//- (float)getValues:(float)number {
//    float i1 = (float)(arc4random() % 5) / 100 ;
//    NSLog(@"%float",i1);
//    return i1;
//}


- (IBAction)addOrRemovePointFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > _previousStepperValue) {
        // Add point
        [self.arrayOfValues addObject:@([self getValues])];
        NSDate *newDate = [self getDate:(NSDate *)[self.arrayOfDates lastObject]];
        [self.arrayOfDates addObject:newDate];
        [self.myGraph reloadGraph];
    } else if (self.graphObjectIncrement.value < self.previousStepperValue) {
        // Remove point
        [self.arrayOfValues removeObjectAtIndex:0];
        [self.arrayOfDates removeObjectAtIndex:0];
        [self.myGraph reloadGraph];
    }
    
    self.previousStepperValue = self.graphObjectIncrement.value;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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