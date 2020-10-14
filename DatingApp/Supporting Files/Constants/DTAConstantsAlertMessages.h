//
//  DTAConstantsAlertMessages.h
//
//

#import <Foundation/Foundation.h>

extern NSString * const DTAInternetConnectionFailed;
extern NSString * const DTAInternetConnectionFailedTitle;

extern NSString * const DTALoginFailed;
extern NSString * const DTAUserBlocked;
extern NSString * const DTAUserRemoved;

#define SHOWALLERT(title, mes) UIAlertView *alertView = \
[[UIAlertView alloc]initWithTitle:title \
message:mes \
delegate:nil \
cancelButtonTitle:@"OK" \
otherButtonTitles:nil];\
[alertView show]

