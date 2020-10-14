//
//  DTABackView.m
//  DatingApp


#import "DTABackView.h"

@implementation DTABackView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(makeButtonTransparent) forControlEvents:UIControlEventTouchDown];
    
    [self addTarget:self action:@selector(makeButtonOpaque) forControlEvents:UIControlEventTouchDragOutside];
    
    [self addTarget:self action:@selector(makeButtonTransparent) forControlEvents:UIControlEventTouchDragInside];
    
    [self addTarget:self action:@selector(makeButtonOpaque) forControlEvents:UIControlEventTouchCancel];
}

- (void)makeButtonTransparent {
    self.alpha = 0.3f;
}

- (void)makeButtonOpaque {
    self.alpha = 1.0f;
}

@end
