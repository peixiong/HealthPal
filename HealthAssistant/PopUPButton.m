//
//  PopUPButton.m
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import "PopUPButton.h"

@implementation PopUPButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)str destinationFrame:(CGRect)destFrame tag:(NSInteger)tag {
    self = [super init];
    if (self) {
        self.frame = frame;
        [self setTitle:str forState:UIControlStateNormal];
        self.tag = tag;
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.cornerRadius = 2.0;
        self.backgroundColor = [UIColor grayColor];
        [self addTarget:self.delegate action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [UIView animateWithDuration:0.35 animations:^{
            self.frame = destFrame;
        }];
    }
    return self;
}

-(void)didSelectButton:(UIButton *)button {
    [self.delegate buttonSelected:button];
}

@end
