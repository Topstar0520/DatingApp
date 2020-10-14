//
//  Religion.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Religion : NSManagedObject

@property (nonatomic, retain) NSString * religionId;
@property (nonatomic, retain) NSString * religionTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
