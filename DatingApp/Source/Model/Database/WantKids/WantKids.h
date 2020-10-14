//
//  WantKids.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WantKids : NSManagedObject

@property (nonatomic, retain) NSString * wantKidsId;
@property (nonatomic, retain) NSString * wantKidsTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
