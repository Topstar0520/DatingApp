//
//  NSString+EMail.h
//  WOWTTO
//
//

#import <Foundation/Foundation.h>

@interface NSString (Email)

- (BOOL)isEmailValid;

+ (NSAttributedString *)generateStringFormName:(NSString *)name location:(NSString *)location;

@end
