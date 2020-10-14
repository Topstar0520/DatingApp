//
//  SubscriptionPlans.m
//  AudioBook
//
//  Created by Tushar  on 28/09/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "SubscriptionPlans.h"

@implementation SubscriptionPlans

-(NSMutableArray *)makeWithPlanArray:(NSArray *)planArr {
    
    NSMutableArray *subModelArr = [NSMutableArray new];
    
    for (NSDictionary *planInfo in planArr) {
        
        SubscriptionPlans *subObj = [SubscriptionPlans new];
//        activate = 1;
//        "bundle_key" = 789789;
//        description = "$6.67 per month";
//        id = 3;
//        price = "79.99";
//        title = "Annual Subscription";
//        type = ios;
        
        NSString *subID = [planInfo objectForKey:@"id"];
        if (![subID isKindOfClass:[NSNull class]]) {
            subObj.subcId  = subID;
        }
        
        NSString *bundleID = [planInfo objectForKey:@"bundle_key"];
        if (![bundleID isKindOfClass:[NSNull class]]) {
            subObj.subBundleId = bundleID;
        }
        NSNumber *discountPrice = [planInfo objectForKey:@"price"];
        if (![discountPrice isKindOfClass:[NSNull class]]) {
            subObj.discountPrice = discountPrice;
        }
        
        NSDictionary *subDes = [planInfo objectForKey:@"description"];
        if (![subDes isKindOfClass: [NSNull class]]) {
            subObj.subDescription = subDes;
        }
        
        NSDictionary *subTag = [planInfo objectForKey:@"marketing_tagline"];
        if (![subTag isKindOfClass: [NSNull class]]) {
            subObj.subTagline = subTag;
        }
        
        NSDictionary *planName = [planInfo objectForKey:@"title"];
        if (![planName isKindOfClass: [NSNull class]]) {
            subObj.planName = planName;
        }
        NSString *key;
        key = @"packageType";
        NSString *pType = [planInfo objectForKey:key];
        if (![pType isKindOfClass:[NSNull class]]) {
            subObj.packType = pType;
        }
        
        NSNumber *pPerPrice = [planInfo objectForKey:@"description"];
        if (![pPerPrice isKindOfClass:[NSNull class]]) {
            subObj.packagePerPrice = pPerPrice;
        }
        
        NSNumber *pDur = [planInfo objectForKey:@"packageDuration"];
        if (![pDur isKindOfClass:[NSNull class]]) {
            subObj.packageDuration = pDur;
        }
        
        NSNumber *planDur = [planInfo objectForKey:@"title"];
        if(![planDur isKindOfClass:[NSNull class]]) {
            subObj.planDuration  = planDur;
        }

        NSNumber *originalPrice = [planInfo objectForKey:@"price"];
        if (![originalPrice isKindOfClass:[NSNull class]]) {
            subObj.originalPrice = originalPrice;
        }

        NSDictionary *isLimit = [planInfo objectForKey:@"limited"];
        if (![isLimit isKindOfClass:[NSNull class]]) {
            subObj.limitedText = isLimit;
        }
          
        [subModelArr addObject:subObj];
    }
    
    return subModelArr;
}

@end
