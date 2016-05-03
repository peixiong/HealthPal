//
//  SuggestionViewController.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/19/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "SuggestionViewController.h"
#import <Firebase/Firebase.h>
#import "FirebaseManager.h"
#import "FoodProperty.h"
@interface SuggestionViewController ()

@end

@implementation SuggestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self sendPOSTRequestWithJasonPostBody];
}

-(void)sendPOSTRequestWithJasonPostBody{
    
    NSURL *url = [NSURL URLWithString:@"https://api.nutritionix.com/v1_1/search"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *tmpJson = [NSMutableDictionary new];
    tmpJson[@"appId"] = @"97e51eca";
    tmpJson[@"appKey"] = @"593a8537db4003bb79f34b9370ae5502";
    tmpJson[@"filters"] = @{@"item_type":@3};
    
    tmpJson[@"offset"] = @0;
    tmpJson[@"limit"] = @5;
    
    NSMutableDictionary *sortDict = [NSMutableDictionary new];
    sortDict[@"field"] = @"nf_calcium_dv";
    sortDict[@"order"] = @"desc";
    tmpJson[@"sort"] = sortDict;
    
    NSArray *fields = @[@"images_front_full_url", @"item_name", @"brand_name", @"nf_calories", @"nf_total_fat", @"nf_sodium", @"nf_total_carbohydrate",@"nf_dietary_fiber",@"nf_sugars",@"nf_protein",@"nf_vitamin_a_dv", @"nf_vitamin_c_dv",@"nf_calcium_dv",@"nf_iron_dv",@"nf_serving_per_container",@"nf_serving_size_qty",@"nf_serving_size_unit",@"nf_serving_weight_grams"];
    tmpJson[@"fields"] = fields;
    
    NSLog(@"tmpJson = %@", tmpJson.description);
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmpJson options:0 error:&error];
    NSLog(@"postData = %@", postData.description);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        NSDictionary *respDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        NSArray *resultArray = respDict[@"hits"];
        if (jsonError) {
            NSLog(@"there is an error loading Json data");
        }
        NSLog(@"there are %lu objects loaded from json",(unsigned long)respDict.count);
        NSLog(@"%@",resultArray.description);
    }];
    [task resume];
}


@end
