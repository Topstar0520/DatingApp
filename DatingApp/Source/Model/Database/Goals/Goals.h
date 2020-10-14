//
//  Goals.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Goals : NSManagedObject

@property (nonatomic, retain) NSString * goalId;
@property (nonatomic, retain) NSString * goalTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
