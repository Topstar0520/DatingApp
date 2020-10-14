//
//  HaveKids.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface HaveKids : NSManagedObject

@property (nonatomic, retain) NSString * haveKidsId;
@property (nonatomic, retain) NSString * haveKidsTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
