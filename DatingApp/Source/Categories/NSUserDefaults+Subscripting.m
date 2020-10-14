
#import "NSUserDefaults+Subscripting.h"

@implementation NSUserDefaults (Subscripting)

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectForKey:(NSString*)key];
}

- (void)setObject:(id)value forKeyedSubscript:(id<NSCopying>)key {
    
    if (value) {
        [self setObject:value forKey:(NSString*)key];
    }
    else {
        [self removeObjectForKey:(NSString*)key];
    }
    
    [self synchronize];
}

@end
