//
//  ScanViewController.m
//  
//
//  Created by Pei Xiong on 4/27/16.
//
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ManualEntryFoodTableViewController.h"
#import "Food.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property AVCaptureSession *session;
@property AVCaptureDevice *device;
@property AVCaptureDeviceInput *input;
@property AVCaptureMetadataOutput *output;
@property AVCaptureVideoPreviewLayer *prevLayer;
@property UIView *highlightView;
@property UILabel *label;
@property Food *food;
@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeUPCECode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[self.prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            self.label.text = detectionString;
            [self.session stopRunning];
            [self loadJsonWithUPC:detectionString];
            break;
        }
        else
            self.label.text = @"Detecting barcode ...";
    }
    
    self.highlightView.frame = highlightViewRect;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.highlightView = [[UIView alloc] init];
    self.highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    self.highlightView.layer.borderWidth = 10;
    [self.view addSubview:self.highlightView];
    
    self.label = [[UILabel alloc] init];
    self.label.frame = CGRectMake(0, self.view.bounds.size.height - 100 - self.tabbarHeight, self.view.bounds.size.width, 100);
    self.label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"Detecting barcode ...";
    [self.view addSubview:self.label];
    
    self.session = [[AVCaptureSession alloc] init];
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (self.input) {
        [self.session addInput:self.input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:self.output];
    
    self.output.metadataObjectTypes = [self.output availableMetadataObjectTypes];
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prevLayer.frame = self.view.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.prevLayer];
    
    [self.session startRunning];
    
    [self.view bringSubviewToFront:self.highlightView];
    [self.view bringSubviewToFront:self.label];
}

-(void)loadJsonWithUPC:(NSString *)str{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.nutritionix.com/v1_1/item?upc=%@&fields=item_name,brand_name,upc,nf_calories,nf_total_fat,nf_sodium,nf_total_carbohydrate,nf_dietary_fiber,nf_sugars,nf_protein,nf_vitamin_a_dv,nf_vitamin_c_dv,nf_calcium_dv,nf_iron_dv,nf_serving_per_container,nf_serving_size_qty,nf_serving_size_unit,nf_serving_weight_grams&appId=97e51eca&appKey=35feb79df2ec3bba88960183e4a929bc", str]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *jsonError;
        NSDictionary *foodInfoFromJason;
        foodInfoFromJason = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (jsonError) {
            NSLog(@"there is an error loading Json data");
        }
        NSLog(@"there are %lu objected loaded from json",(unsigned long)foodInfoFromJason.count);
        NSLog(@"%@",foodInfoFromJason.description);
        if (![foodInfoFromJason objectForKey:@"error_code"])  { // No error:
            self.food = [Food new];
            self.food.foodProperties[1].value = foodInfoFromJason[@"item_name"];
            self.food.foodProperties[2].value = [NSString stringWithString:foodInfoFromJason[@"brand_name"]];
            self.food.foodProperties[3].value = [NSString stringWithFormat:@"%@ %@", foodInfoFromJason[@"nf_serving_size_qty"], foodInfoFromJason[@"nf_serving_size_unit"]];
            self.food.foodProperties[4].value = @"1";
            self.food.foodProperties[5].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_calories"]];
            self.food.foodProperties[6].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_total_carbohydrate"]];
            self.food.foodProperties[7].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_protein"]];
            self.food.foodProperties[8].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_total_fat"]];
            self.food.foodProperties[9].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_sugars"]];
            self.food.foodProperties[10].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_dietary_fiber"]];
            self.food.foodProperties[11].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_sodium"]];
            self.food.foodProperties[12].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_calcium_dv"]];
            self.food.foodProperties[13].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_iron_dv"]];
            self.food.foodProperties[14].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_vitamin_a_dv"]];
            self.food.foodProperties[15].value = [NSString stringWithFormat:@"%@", foodInfoFromJason[@"nf_vitamin_c_dv"]];
            if ([self.food.foodProperties[2].value isEqualToString:@"Nutritionix"]) {
                self.food.foodProperties[2].value = @"";
            }
            for (int i = 5; i<self.food.foodProperties.count; i++) {
                if ([self.food.foodProperties[i].value isEqualToString:@"<null>"]) {
                    self.food.foodProperties[i].value = @"";
                }
                self.food.foodProperties[i].value = [NSString stringWithFormat:@"%li", (long)[self.food.foodProperties[i].value integerValue]];
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                ManualEntryFoodTableViewController *vc = [[UIStoryboard storyboardWithName:@"ManualEntry" bundle:nil] instantiateViewControllerWithIdentifier:@"manualEntry"];
                vc.food = self.food;
                vc.user = self.user;
                [self.navigationController pushViewController:vc animated:true];
            });
        } else {
            //error scan;
        }
    }];
    [task resume];
}


@end
