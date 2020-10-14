//
//  NSString+EMail.m
//
//

#import "NSString+Email.h"

@implementation NSString (Email)

- (BOOL)isEmailValid {
    
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

+ (NSAttributedString *)generateStringFormName:(NSString *)name location:(NSString *)location {
    
    NSMutableAttributedString *nameLocation = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", name, location]];

    [nameLocation addAttribute:NSForegroundColorAttributeName value:colorBlue range:NSMakeRange(0,name.length)];

    [nameLocation addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f] range:NSMakeRange(0, name.length)];

    [nameLocation addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(name.length+1,location.length)];

    [nameLocation addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f] range:NSMakeRange(name.length+1, location.length)];

    return nameLocation;
}

@end
