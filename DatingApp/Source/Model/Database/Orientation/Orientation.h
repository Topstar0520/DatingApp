//
//  Orientation.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Orientation : NSManagedObject

@property (nonatomic, retain) NSString * orientationId;
@property (nonatomic, retain) NSString * orientationTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
