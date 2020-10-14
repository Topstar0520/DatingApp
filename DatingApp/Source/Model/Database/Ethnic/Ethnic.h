//
//  Ethnic.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Ethnic : NSManagedObject

@property (nonatomic, retain) NSString * ethnicId;
@property (nonatomic, retain) NSString * ethnicTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
