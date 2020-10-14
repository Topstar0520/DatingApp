//
//  SubscriptionPlans.h
//  AudioBook
//
//  Created by Tushar  on 28/09/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubscriptionPlans : NSObject

//subscription Id
@property(nonatomic,strong) NSString *subcId;

//discount
@property(nonatomic,strong) NSNumber *discountPrice;

//plan duration
@property(nonatomic,strong) NSNumber *planDuration;

//original price
@property(nonatomic,strong) NSNumber *originalPrice;

//subscription product id
@property(nonatomic,strong) NSString *subBundleId;

//limited
@property(nonatomic,strong) NSDictionary *limitedText;

//featured
//@property(nonatomic,strong) NSNumber *isFeatured;

//plan description
@property(nonatomic,strong) NSDictionary *subDescription;

//plan tagline
@property(nonatomic,strong) NSDictionary *subTagline;

//plan name
@property(nonatomic,strong) NSDictionary *planName;

@property(nonatomic,strong) NSString *packType;
@property(nonatomic,strong) NSNumber *packagePerPrice;
@property(nonatomic,strong) NSNumber *packageDuration;

//plan selection
@property(nonatomic,assign) BOOL isPLanSelected;

-(NSMutableArray *)makeWithPlanArray:(NSArray *)planArr;


@end
