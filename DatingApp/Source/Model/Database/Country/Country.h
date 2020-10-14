//
//  Country.h
//  
//
//  Created by  Artem Kalinovsky on 8/13/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * countryId;
@property (nonatomic, retain) NSString * countryTitle;
@property (nonatomic, retain) NSNumber * isDefault;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
