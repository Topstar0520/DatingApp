//
//  DTASwipeImages.h
//  DatingApp


#import <UIKit/UIKit.h>

@interface DTASwipeImages : UIScrollView

@property (nonatomic, strong) NSArray *images;

- (void)cleanImagesWithAnimation:(BOOL)animated onComplete:(DTAAPISuccessErrorCompletionBlock)completionBlock;
- (void)addImages:(NSArray *)images animated:(BOOL)animated;

- (void)showPageControl;
- (void)hidePageControl;

- (int)currentImageIndex;

- (BOOL)isArrayOfImagesEqualToCurrentArray:(NSArray *)arrayImages;

@end
