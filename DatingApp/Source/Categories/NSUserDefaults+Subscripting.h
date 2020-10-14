
#import <Foundation/Foundation.h>

#define NS_USER_DEFAULTS(key) [NSUserDefaults standardUserDefaults][key]

@interface NSUserDefaults (Subscripting)

- (id)objectForKeyedSubscript:(id <NSCopying>)key;
- (void)setObject:(id)value forKeyedSubscript:(id <NSCopying>)key;

@end
