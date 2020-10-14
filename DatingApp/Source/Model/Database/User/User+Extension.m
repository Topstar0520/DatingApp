//
//  User+Extension.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 7/31/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "User+Extension.h"
#import "Location.h"
#import "Image.h"
#import "Image+Extensions.h"

@implementation User (Extension)

+ (User *)currentUser {
    return [self MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"NOT (session.accessToken == NIL)"]];
}

- (void)fetchProfilePictureWithCompletionBlock:(void (^)(UIImage *fetchedImage, NSError *error))completionBlock {
    
    if (self.avatar) {
        
//        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.avatar] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//            
//            if (image && finished) {
//                // Cache image to disk or memory
//                completionBlock(image, nil);
//            }
//            else {
//                completionBlock(nil, error);
//            }
//        }];
    }
}

- (NSString *)fetchCityNameFromLocation {
    
    NSArray *items = [self.location.locationTitle componentsSeparatedByString:@","];
   
    if (items.count > 1) {
        return [items firstObject];
    }
    else {
        //DEV we will show blank Str
        if (self.location.locationTitle == nil){
            return @"";
        }
        
        return self.location.locationTitle;
    }
}

- (NSString *)convertHeightToString {
    
    NSUInteger inchesTotal = self.heightValue.integerValue;
    NSUInteger feet = inchesTotal / 12;
    NSUInteger inches = inchesTotal % 12;
    NSString *result = [NSString stringWithFormat:@"%lu ft %lu inch", (unsigned long)feet, (unsigned long)inches];

    return result;
}

- (NSInteger)userAge {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"YYYY-MM-DD";
   
    NSDate *birthDate = [dateFormatter dateFromString:self.stringDateOfBirth];
    
    NSDate *today = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSUInteger units = NSCalendarUnitYear;
    
    NSDateComponents *components = [gregorian components:units fromDate:birthDate toDate:today options:0];
    
    return [components year];
}

@end
