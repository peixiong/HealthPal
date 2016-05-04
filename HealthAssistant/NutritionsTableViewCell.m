//
//  NutritionsTableViewCell.m
//  HealthAssistant
//
//  Created by David Iskander on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "NutritionsTableViewCell.h"
#import "NutritionCategory.h"
#import "FirebaseManager.h"
#import "Food.h"
#import "OneDayData.h"


@implementation NutritionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)getPointsWithCompletionHandler:(void (^)(void))completionBlock{
    NSLog(@"Expecting calories to be non zero");
    if (self.calories.points.count > 0)
    {
        completionBlock();
    }
}



-(void)loadCell{
    
    self.dates = [NSMutableArray new];
    self.allDaysData = [NSMutableArray new];
    
    //Setting Delegates
    [FirebaseManager sharedInstance].delegate = self;
    self.nutritionsButtonView.delegate = self;
    self.nutritionsButtonView.dataSource = self;
    
    NSLog(@"Getting points...");
    [self retriveLifetimeUserLoggedFoodIDs];

    
    self.calories = [NutritionCategory new];
    self.calories.title = @"Calories";
    self.calories.date = [NSDate date];
    self.calories.points = [NSMutableArray new];
    
    self.carbs = [NutritionCategory new];
    self.carbs.title = @"Carbs";
    self.carbs.date = [NSDate date];
    self.carbs.points = [NSMutableArray new];
    
    self.sodium = [NutritionCategory new];
    self.sodium.title = @"Sodium";
    self.sodium.date = [NSDate date];
    self.sodium.points = [NSMutableArray new];
    
    self.protien = [NutritionCategory new];
    self.protien.title = @"Protien";
    self.protien.date = [NSDate date];
    self.protien.points = [NSMutableArray new];
    
    self.sugar = [NutritionCategory new];
    self.sugar.title = @"Sugar";
    self.sugar.date = [NSDate date];
    self.sugar.points = [NSMutableArray new];
    
    self.vitA = [NutritionCategory new];
    self.vitA.title = @"Vitamin A";
    self.vitA.date = [NSDate date];
    self.vitA.points = [NSMutableArray new];
    
    self.vitC = [NutritionCategory new];
    self.vitC.title = @"Vitamin C";
    self.vitC.date = [NSDate date];
    self.vitC.points = [NSMutableArray new];
    
    self.fat = [NutritionCategory new];
    self.fat.title = @"Fat";
    self.fat.date = [NSDate date];
    self.fat.points = [NSMutableArray new];
    
    self.fiber = [NutritionCategory new];
    self.fiber.title = @"Fiber";
    self.fiber.date = [NSDate date];
    self.fiber.points = [NSMutableArray new];
    
    self.iron = [NutritionCategory new];
    self.iron.title = @"Iron";
    self.iron.date = [NSDate date];
    self.iron.points = [NSMutableArray new];
    
    self.calcium = [NutritionCategory new];
    self.calcium.title = @"Calcium";
    self.calcium.date = [NSDate date];
    self.calcium.points = [NSMutableArray new];

    
    
    self.nutritionsArray = [NSArray arrayWithObjects:self.calories,self.carbs,self.sodium, self.protien, self.sugar, self.fat, self.fiber, self.calcium,self.iron, self.vitA, self.vitC, nil];

}



-(void)retriveLifetimeUserLoggedFoodIDs{
    NSLog(@"Retrieving...");
    
    NSMutableArray *tempAllDays = [NSMutableArray new];
    
    self.dataForAllDays = [[NSMutableArray alloc]init];
    for (NSString *dateString in self.user.timeFood.allKeys) {
        
        NSLog(@"This is the date string: %@", dateString);
        
        
        //testing date conversion
        NSDateFormatter *dateformat = [NSDateFormatter new];
        [dateformat setDateFormat:@"yyyyMMdd"];
        NSDate *firebaseDateFormat = [dateformat dateFromString:dateString];
        OneDayData *oneDay = [[OneDayData alloc]init];
        
        oneDay.date = firebaseDateFormat;
        
        NSLog(@"Converted NSDATE: %@", oneDay.date);
        
        
        NSDictionary *oneDayfood = self.user.timeFood[dateString];
        NSLog(@"food: %@", oneDayfood);
        
        oneDay.keyIDs = oneDayfood.allValues;
        NSLog(@"Foodvalues: %@",oneDay.keyIDs);
        
        [tempAllDays addObject:oneDay];

        //[self.allDaysData addObject:oneDay];
  
        
    }
    
    NSSortDescriptor *sortDates = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDates];
    self.allDaysData = [[tempAllDays sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    

    [self retriveTotalNutritionsToEachDay:self.allDaysData];
}


-(void)retriveTotalNutritionsToEachDay:(NSArray *)allDays{
    
    for (OneDayData *day in allDays)
    {
    
        NSLog(@"Retreiving each day...");
        
        for (int i; i < foodItemArray.count; i++) {
            NSNumber *fpID = [[foodItemArray objectAtIndex:i] objectForKey:@"fpId"];
            NSLog(@"current fpid: %@", [[foodItemArray objectAtIndex:i] objectForKey:@"fpId"]);
            NSLog(@"food item: %@", [foodItemArray objectAtIndex:i]);
            
            
            // Calories
            if ([fpID intValue] == 5)
            {
                NSDictionary *caloriesDict = [foodItemArray objectAtIndex:i];
                NSString *calorieValue = [caloriesDict objectForKey:@"value"];
                NSLog(@"%@", calorieValue);
                [self.calories.points addObject:calorieValue];
                NSLog(@"Cal total: %@", self.calories.points);
            }
            
            // Carbs
            if ([fpID intValue] == 6)
            {
                NSDictionary *carbsDict = [foodItemArray objectAtIndex:i];
                NSNumber *carbsValue = [carbsDict objectForKey:@"value"] ;
                [self.carbs.points addObject:carbsValue];
                NSLog(@"Carb total: %@", self.carbs.points);
            }
            
            
            // Protien
            if ([fpID intValue] == 7)
            {
                NSDictionary *protienDict = [foodItemArray ogitbjectAtIndex:i];
                NSNumber *protienValue = [protienDict objectForKey:@"value"] ;
                [self.protien.points addObject:protienValue];
                NSLog(@"protien total: %@", self.protien.points);
            }
            
            
            // fat
            if ([fpID intValue] == 8)
            {
                NSDictionary *fatDict = [foodItemArray objectAtIndex:i];
                NSNumber *fatValue = [fatDict objectForKey:@"value"] ;
                [self.fat.points addObject:fatValue];
                NSLog(@"fat total: %@", self.fat.points);
            }
            
            
            
            // Sugar
            if ([fpID intValue] == 9)
            {
                NSDictionary *sugarDict = [foodItemArray objectAtIndex:i];
                NSNumber *sugarValue = [sugarDict objectForKey:@"value"] ;
                [self.sugar.points addObject:sugarValue];
                NSLog(@"sugar total: %@", self.sugar.points);
            }
            
            
            // Sodium
            if ([fpID intValue] == 10)
            {
                NSDictionary *sodiumDict = [foodItemArray objectAtIndex:i];
                NSNumber *sodiumValue = [sodiumDict objectForKey:@"value"];
                [self.sodium.points addObject:sodiumValue];
                NSLog(@"sodium total: %@", self.sodium.points);
            }
            
            // Calcium
            if ([fpID intValue] == 11)
            {
                NSDictionary *calciumDict = [foodItemArray objectAtIndex:i];
                NSNumber *calciumValue = [calciumDict objectForKey:@"value"];
                [self.calcium.points addObject:calciumValue];
                NSLog(@"Calsium total: %@", self.calcium.points);
            }
            
            // Calcium
            if ([fpID intValue] == 11)
            {
                NSDictionary *calciumDict = [foodItemArray objectAtIndex:i];
                NSNumber *calciumValue = [calciumDict objectForKey:@"value"];
                [self.calcium.points addObject:calciumValue];
                NSLog(@"Calsium total: %@", self.calcium.points);
            }
            [self.dates addObject:day.date];
            NSLog(@"One day data has been parsed with date ONE DAY: %@", day.date);
            NSLog(@"One day data has been parsed with date ARRAY: %@", self.dates);
            
            
            
            //render stuff with a completion block...
            [self getPointsWithCompletionHandler:^{
                [self cellTitle];
                [self hydrateDatasets];
                [self createGraph];
                [self.contentView addSubview:self.myGraph];
                [self graphProperties];
                [self drawAverageLine];
                [self graphLabels];
                [self gradientForGraphLine];
            }];
            
            
            
        } withCancelBlock:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }
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
    self.buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellX, cellY, 100, 40)];
    self.buttonLabel.text = [[self.nutritionsArray objectAtIndex:indexPath.row]title];
    self.buttonLabel.clipsToBounds = YES;
    self.buttonLabel.layer.masksToBounds = YES;
    self.buttonLabel.layer.cornerRadius = 8.0;
    //self.buttonLabel.layer.borderWidth = 1;
    //self.buttonLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.buttonLabel.textColor = [UIColor blackColor];
    self.buttonLabel.backgroundColor = [UIColor colorWithRed:184/255 green:195/255 blue:255/255 alpha:0.2];
    self.buttonLabel.textAlignment = NSTextAlignmentCenter;
    [self.nutritionsButtonView addSubview:self.buttonLabel];

    return cell;
}


// size of each cell in the UICollectionView
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(95, 40);
}


// Action on cell pressed
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    //    [nc getDataFromFireBase];

    //NutritionCategory *nc = self.nutritionsArray[indexPath.row];
    //NSLog(@"%@",nc);
    //NSLog(@"touched cell %@ at indexPath %@", cell, indexPath);
    
    if (indexPath.row == 0)
    {
        self.arrayOfValues = self.calories.points;
        //self.arrayOfDates = self.dates;
        [self.myGraph reloadGraph];
    }
    if (indexPath.row == 1)
    {
        self.arrayOfValues = self.carbs.points;
        [self.myGraph reloadGraph];

    }
    
    if (indexPath.row == 2)
    {
        self.arrayOfValues = self.sodium.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 3)
    {
        self.arrayOfValues = self.protien.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 4)
    {
        self.arrayOfValues = self.sugar.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 5)
    {
        self.arrayOfValues = self.fat.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 6)
    {
        self.arrayOfValues = self.fiber.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 7)
    {
        self.arrayOfValues = self.calcium.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 8)
    {
        self.arrayOfValues = self.iron.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 9)
    {
        self.arrayOfValues = self.vitA.points;
        [self.myGraph reloadGraph];
        
    }
    if (indexPath.row == 10)
    {
        self.arrayOfValues = self.vitC.points;
        [self.myGraph reloadGraph];
        
    }

    
    else
    {
        NSLog(@"Invalid button");
    }
    
    
}


#pragma mark - Graph Methods

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
    self.label.text = @"Nutritions Dashboard";
    //self.label.layer.masksToBounds = YES;
    //self.label.layer.cornerRadius = 8.0;
    //self.label.layer.borderWidth = 1;
    //self.label.layer.borderColor = [UIColor blackColor].CGColor;
    self.label.textColor = [UIColor blackColor];
    //self.label.backgroundColor = [UIColor lightGrayColor];
}



// Draw an average line for values on the graph
- (void)drawAverageLine{
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.5;
    self.myGraph.averageLine.color = [UIColor blueColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
}



//Creating a graph
-(void)createGraph{
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(20, 100, self.frame.size.width-40, self.frame.size.height-200)];
    
    self.myGraph.enableBezierCurve = YES;
    self.myGraph.dataSource = self;
    self.myGraph.delegate = self;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.layer.masksToBounds = YES;
    self.myGraph.layer.cornerRadius = 8.0;
//    self.myGraph.backgroundColor = [UIColor colorWithRed:0/255 green:255/255 blue:127/255 alpha:1.0];
//    self.myGraph.colorTop = [UIColor colorWithRed:0/255 green:255/255 blue:127/255 alpha:1.0];
//    self.myGraph.colorBottom = [UIColor colorWithRed:0/255 green:255/255 blue:127/255 alpha:1.0];
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
    //self.labelDates.textColor = [UIColor whiteColor];
    //self.labelValues.textColor = [UIColor whiteColor];
    
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
    //NSDate *baseDate = [NSDate date];
    //BOOL showNullValue = true;
    
    
    // Add objects to the array based on the stepper value
    for (int i = 0; i < self.calories.points.count; i++) {

        [self.arrayOfValues addObject:self.calories.points[i]];
        
        
        [self.arrayOfDates addObject:self.dates[i]];
        
        
//        if (i == 0) {
//            //[self.arrayOfDates addObject:baseDate];
//            [self.arrayOfDates addObject:self.dates];
//            //NSLog(@"Current Date: %@", baseDate);
//            
//        } else if (showNullValue && i == 4) {
//            //[self.arrayOfDates addObject:[self getDate:self.arrayOfDates[i-1]]];
//            [self.arrayOfDates addObject:self.dates[i-1]];
//            self.arrayOfValues[i] = @(BEMNullGraphValue);
//            
//        } else {
//            //[self.arrayOfDates addObject:[self getDate:self.arrayOfDates[i-1]]];
//            [self.arrayOfDates addObject:self.dates[i]];
//        }
        
        self.totalNumber = self.totalNumber + [[self.arrayOfValues objectAtIndex:i] intValue]; // All of the values added together
    }
    
    [self.myGraph reloadGraph];
}



//Getting one more day on pressing (+)
- (NSDate *)getDate:(NSDate *)date {
    NSTimeInterval secondsInTwentyFourHours = 24 * 60 * 60;
    NSDate *newDate = [date dateByAddingTimeInterval:secondsInTwentyFourHours];
    return newDate;
}


// Returns the dates on label
- (NSString *)labelForDateAtIndex:(NSInteger)index {
    //NSDate *date = self.arrayOfDates[index];
    NSDate *date = self.dates[index];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM/dd";
    NSString *label = [df stringFromDate:date];
    return label;
}




- (IBAction)addOrRemovePointFromGraph:(id)sender {
    if (self.graphObjectIncrement.value > _previousStepperValue) {

        NSLog(@" + pressed");
        if (self.arrayOfValues.count > 2)
        {
            [self.arrayOfValues removeLastObject];
            [self.arrayOfDates removeLastObject];
            [self.myGraph reloadGraph];
        }
        else
        {
            NSLog(@"can't zoom in more than that");
        }
        
        
    } else if (self.graphObjectIncrement.value < self.previousStepperValue) {
        // Remove point
        NSLog(@" - pressed");
        self.arrayOfValues = self.points;
        self.arrayOfDates = self.dates;
        
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
