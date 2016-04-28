//
//  ScanViewController.m
//  
//
//  Created by Pei Xiong on 4/27/16.
//
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property AVCaptureSession *session;
@property AVCaptureDevice *device;
@property AVCaptureDeviceInput *input;
@property AVCaptureMetadataOutput *output;
@property AVCaptureVideoPreviewLayer *prevLayer;
@property UIView *highlightView;
@property UILabel *label;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
//            [self.session stopRunning];
//            [self performSegueWithIdentifier:@"test" sender:self];
//            break;
        }
        else
            self.label.text = @"Detecting barcode ...";
    }
    
    self.highlightView.frame = highlightViewRect;
}

@end
