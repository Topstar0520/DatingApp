//
//  DTADraggableImages.h
//  DatingApp


#import <UIKit/UIKit.h>
#import "User+Extension.h"

@protocol DTAPressAddImage

@required

- (void)pressAddImageButton;

@end

@interface DTADraggableImages : UIView

@property (nonatomic, strong) User *user;

@property (atomic, assign) BOOL stopLoad;

@property (nonatomic, weak) id <DTAPressAddImage>delegate;

- (void)setImage;
- (void)uploadImage:(UIImage *)image;

@end
