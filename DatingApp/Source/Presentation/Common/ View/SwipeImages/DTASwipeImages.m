//
//  DTASwipeImages.m
//  DatingApp


#import "DTASwipeImages.h"

@interface DTASwipeImages()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation DTASwipeImages

#pragma mark - Private

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if(!self.pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.userInteractionEnabled = NO;
    }
}

- (void)changePageIndex {
    CGFloat pageWidth = self.frame.size.width;
    float fractionalPage = self.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

#pragma mark - Public

- (void)cleanImagesWithAnimation:(BOOL)animated onComplete:(DTAAPISuccessErrorCompletionBlock)completionBlock {
    DTAAPISuccessErrorCompletionBlock completionCopy = [completionBlock copy];
    
    self.images = nil;
    
    float duration = 0.3f;
    
    if(!animated) {
        duration = 0.0f;
    }
    
    [UIView animateWithDuration:duration animations:^{
         for(UIView *subview in self.subviews) {
             if([subview isKindOfClass:[UIImageView class]] && subview.tag) {
                 subview.alpha = 0.0f;
             }
         }
     } completion:^(BOOL finished) {
         for(UIView *subview in self.subviews) {
             if([subview isKindOfClass:[UIImageView class]] && subview.tag) {
                 [subview removeConstraints:subview.constraints];
                 [subview removeFromSuperview];
             }
         }
         
         [self scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
         
         if(completionCopy) {
             completionCopy(nil);
         }
     }];
}

- (void)addImages:(NSArray *)images animated:(BOOL)animated {
    
    NSArray *sortedArray = [images sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    
    NSArray *pathesArray = [sortedArray valueForKeyPath:@"path"];
    
    self.images = [NSArray arrayWithArray:pathesArray];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    int i = 0;
    
    float duration = 0.3;
    
    if (!animated) {
        duration = 0.0f;
    }
    
    self.pageControl.numberOfPages = self.images.count;
    
    for (NSString *imageUrl in self.images) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        
        [imgView setContentMode:UIViewContentModeScaleAspectFill];
        imgView.tag = i + 1;
        imgView.layer.masksToBounds = YES;
        imgView.alpha = 0.0f;
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"drefaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
             [UIView animateWithDuration:duration animations:^{
                  imgView.alpha = 1.0f;
              }];
         }];
        
        imgView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:imgView];
        
        NSLayoutConstraint *imgViewWidthConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:SCREEN_WIDTH];
        
        NSLayoutConstraint *imgViewHeightConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:SCREEN_WIDTH];
        
        [imgView addConstraints:@[imgViewHeightConstraint, imgViewWidthConstraint]];
        
        NSLayoutConstraint *imgViewTopSpacingConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *imgViewBottomSpacingConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *imgViewLeadingSpacingConstraint;
        NSLayoutConstraint *imgViewTrailingSpacingConstraint;
        
        if (i == 0) {
            imgViewLeadingSpacingConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0];
        }
        else {
            imgViewLeadingSpacingConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[self viewWithTag:i] attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        }
        
        if (i == (self.images.count - 1)) {
            imgViewTrailingSpacingConstraint = [NSLayoutConstraint constraintWithItem:imgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0];
        }
        
        if (imgViewTrailingSpacingConstraint) {
            [self addConstraints:@[imgViewLeadingSpacingConstraint, imgViewTrailingSpacingConstraint, imgViewTopSpacingConstraint, imgViewBottomSpacingConstraint]];
        }
        else {
            [self addConstraints:@[imgViewLeadingSpacingConstraint, imgViewTopSpacingConstraint, imgViewBottomSpacingConstraint]];
        }
        
        ++i;
    }
    
    if(!self.pageControl.superview) {
        
        [self.superview addSubview:self.pageControl];
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *pageControlBottomSpacingConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *pageControlLeadingSpacingConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
        
        NSLayoutConstraint *pageControlWidthConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeWidth multiplier:1.0 constant:SCREEN_WIDTH];
        
        NSLayoutConstraint *pageControlHeightConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:30];
        
        [self.pageControl addConstraints:@[pageControlHeightConstraint, pageControlWidthConstraint]];
        
        [self.superview addConstraints:@[pageControlBottomSpacingConstraint, pageControlLeadingSpacingConstraint]];
    }
    
    self.pageControl.currentPage = 0;
}

- (void)showPageControl {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.pageControl.alpha = 1.0f;
    }];
}

- (void)hidePageControl {
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.pageControl.alpha = 0.0f;
    }];
}

- (int)currentImageIndex {
    return (int)self.pageControl.currentPage;
}

- (BOOL)isArrayOfImagesEqualToCurrentArray:(NSArray *)arrayImages; {
    NSArray *sortedArray = [arrayImages sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]];
    NSArray *pathesArray = [sortedArray valueForKeyPath:@"path"];
    NSArray *newArray = [NSArray arrayWithArray:pathesArray];
    
    if ([newArray isEqualToArray:self.images]) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - UIScrollView delegate methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self changePageIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self changePageIndex];
}

@end
