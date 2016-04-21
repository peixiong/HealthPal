//
//  FirebaseManager.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/20/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

@protocol FirebaseManagerDelegate <NSObject>



@end

@interface FirebaseManager : NSObject

+ (instancetype)sharedInstance;
@property id<FirebaseManagerDelegate> delegate;
@end
