//
//  Profession.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Profession : NSManagedObject

@property (nonatomic, retain) NSString * professionId;
@property (nonatomic, retain) NSString * professionTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
