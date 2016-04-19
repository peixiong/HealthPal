//
//  PopUPButton.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/18/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopUPButtonDelegate
-(void)buttonSelected:(UIButton *)button;
@end


@interface PopUPButton : UIButton
@property id<PopUPButtonDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)str destinationFrame:(CGRect)destFrame tag:(NSInteger)tag;

@end
