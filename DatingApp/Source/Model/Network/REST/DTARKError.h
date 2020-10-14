//
//  DTARKError.h

#import <Foundation/Foundation.h>

@interface DTARKError : NSObject

@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *code;

@end
