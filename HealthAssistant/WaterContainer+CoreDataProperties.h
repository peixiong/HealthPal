//
//  WaterContainer+CoreDataProperties.h
//  HealthAssistant
//
//  Created by Pei Xiong on 4/29/16.
//  Copyright © 2016 Pei Xiong. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WaterContainer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WaterContainer (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *containerImageDaTa;
@property (nullable, nonatomic, retain) NSNumber *size;

@end

NS_ASSUME_NONNULL_END
