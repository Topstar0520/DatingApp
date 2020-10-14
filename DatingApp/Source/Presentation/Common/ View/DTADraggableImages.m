//
//  DTADraggableImages.m
//  DatingApp

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "DTADraggableImages.h"
#import "Image+Extensions.h"
#import "MBProgressHUD.h"
#import "DTADraggableImagesButton.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SAMHUDView.h"

static float kActionButtonWidth = 50.0f;
static int kActionImageTag = 20;

@interface DTADraggableImages()<UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) CGPoint initialPositionOfDraggableView;
@property (nonatomic, strong) DTADraggableImagesButton *selectedButton;
@property (nonatomic, assign) NSInteger indexOfViewForRemove;
@property (nonatomic, strong) DTADraggableImagesButton *testButton;
@property (nonatomic, assign) BOOL isImageCanBeDragged;
@property (nonatomic, strong) NSMutableArray *userImages;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

@end

@implementation DTADraggableImages

- (void)setFrame:(CGRect)frame {
    [super setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stopLoad = NO;
    
    for(DTADraggableImagesButton *button in self.buttons) {
        
        [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        
        [button addTarget:self action:@selector(imageMoved:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        
        [button addTarget:self action:@selector(touchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
        
        [button addTarget:self action:@selector(touchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [button addTarget:self action:@selector(touchUp:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        
        [button addTarget:self action:@selector(touchUp:withEvent:) forControlEvents:UIControlEventTouchCancel];
        
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.tag = kActionImageTag;
        
        actionBtn.frame = CGRectMake(button.frame.size.width - kActionButtonWidth, button.frame.size.height - kActionButtonWidth, kActionButtonWidth, kActionButtonWidth);
        
        [actionBtn setImage:[UIImage imageNamed:@"bt_plus_photo"] forState:UIControlStateNormal];
        
        [actionBtn setImage:[UIImage imageNamed:@"bt_plus_photo"] forState:UIControlStateHighlighted];
        
        [actionBtn setImage:[UIImage imageNamed:@"bt_minus_photo"] forState:UIControlStateSelected];
        
        [actionBtn addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [button addSubview:actionBtn];
    }
}

#pragma mark - Private methods

- (void)shiftImages {
    NSInteger indexOfRemovedView = self.indexOfViewForRemove;
    int indexOfLastDraggableButtonWithImage = [self indexOfLastDraggableButtonWithImage];
    
    if(indexOfRemovedView < indexOfLastDraggableButtonWithImage) {
        
        //need to shift images
        
        for(NSInteger i = indexOfRemovedView; i < indexOfLastDraggableButtonWithImage; ++i) {
            
            DTADraggableImagesButton *firstView = self.buttons[i + 1];
            DTADraggableImagesButton *secondView = self.buttons[i];
            
            UIImage *image = [firstView imageForState:UIControlStateNormal];
            [firstView setImage:[secondView imageForState:UIControlStateNormal] forState:UIControlStateNormal];
            [secondView setImage:image forState:UIControlStateNormal];
            
            UIImageView *firstImgView = (UIImageView *)self.imageViews[[self.buttons indexOfObject:firstView]];
            UIImageView *secondImgView = (UIImageView *)self.imageViews[[self.buttons indexOfObject:secondView]];
            
            image = firstImgView.image;
            firstImgView.image = secondImgView.image;
            secondImgView.image = image;
            
            NSString *imageId = firstView.imageId;
            firstView.imageId = secondView.imageId;
            secondView.imageId = imageId;
        }
    }
    
    if(indexOfRemovedView == 0) {
        [self setAvatarImageFromView:self.buttons[0]];
    }
}

- (int)indexOfLastDraggableButtonWithImage {
    
    int index = -1;
    int i = 0;
    
    for (DTADraggableImagesButton *button in self.buttons) {
        if ([button imageForState:UIControlStateNormal]) {
            index = i;
        }
        
        ++i;
    }
    
    return index;
}

- (DTADraggableImagesButton *)draggableButtonForAddingImage {
    for (DTADraggableImagesButton *button in self.buttons) {
        if (![button imageForState:UIControlStateNormal]) {
            return button;
        }
    }
    
    return nil;
}

- (void)hideActionButtons {
    for(DTADraggableImagesButton *button in self.buttons) {
        [UIView animateWithDuration:0.1 animations:^ {
            [button viewWithTag:kActionImageTag].alpha = 0.0f;
        }];
    }
}

- (void)showActionButtons {
    for(DTADraggableImagesButton *button in self.buttons) {
        [UIView animateWithDuration:0.1 animations:^ {
            [button viewWithTag:kActionImageTag].alpha = 1.0f;
        }];
    }
}

- (void)setImage {
    
    self.userImages = [NSMutableArray array];
    
    if(self.user.image.count) {
        self.userImages = [[[self.user.image allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]]] mutableCopy];
    }
    
    int i = 0;
    
    for(Image *image in self.userImages) {
        
        [self.buttons[i] sd_setImageWithURL:[image fetchPictureUrl] forState:UIControlStateNormal];
     
        [(UIImageView *)self.imageViews[i] sd_setImageWithURL:[image fetchPictureUrl]];
        
        [(UIImageView *)self.imageViews[i]setContentMode:UIViewContentModeScaleAspectFill];
        
        ((DTADraggableImagesButton *)[self viewWithTag:i + 1]).imageId = image.imageId;
        
        [(UIButton *)[self.buttons[i] viewWithTag:kActionImageTag] setSelected:YES];
        
        [(UIButton *)[self.buttons[i] viewWithTag:kActionImageTag] setImage:[UIImage imageNamed:@"bt_minus_photo"] forState:UIControlStateHighlighted | UIControlStateSelected];
        
        ++i;
    }
    
    [self checkVisibilityOfFirstActionButton];
    
}

- (void)setAvatarImageFromView:(DTADraggableImagesButton *)button {
    if([self.buttons indexOfObject:button] == 0 && button.imageId) {
        [DTAAPI setAvatarProfileImageId:button.imageId WithCompletion:^(NSError *error) {
             if(!error) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatar" object:nil];
             }
         }];
    }
}

- (void)sendAvatarImage:(UIView *)avatarView {
    
}

- (void)uploadImage:(UIImage *)image {
    SAMHUDView *hudView = [[SAMHUDView alloc] initWithTitle:NSLocalizedString(@"Uploading...", nil)];
    [hudView show];
    
    __weak typeof(self) weakSelf = self;
    
    [DTAAPI uploadProfileImage:image WithCompletion:^(NSError *error, id result) {
         if (!error) {
             if([weakSelf.buttons indexOfObject:weakSelf.selectedButton] == 0) {
                 [weakSelf setAvatarImageFromView:weakSelf.selectedButton];
             }
             
             NSMutableArray *idsArray = [NSMutableArray array];
             
             for(DTADraggableImagesButton *button in weakSelf.buttons) {
                 if(button.imageId) {
                     [idsArray addObject:button.imageId];
                 }
             }
             
             [idsArray addObject:result[@"id"]];
             
             [DTAAPI setImagesOrder:idsArray withCompletion:^(NSError *error, NSArray *resultAr) {
                 if(!error) {
                     [weakSelf.selectedButton sd_setImageWithURL:[NSURL URLWithString:[result objectForKey:@"path"]] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                          if(!error) {
                              [weakSelf.selectedButton setImage:image forState:UIControlStateNormal];
                            
                              [weakSelf.selectedButton setImageId:[(NSDictionary *)result objectForKey:@"id"]];
                              
                              [weakSelf.imageViews[[weakSelf.buttons indexOfObject:weakSelf.selectedButton]] setImage:image];
                              
                              [weakSelf.imageViews[[weakSelf.buttons indexOfObject:weakSelf.selectedButton]] setContentMode:UIViewContentModeScaleAspectFill];
                              
                              [(UIButton *)[weakSelf.selectedButton viewWithTag:kActionImageTag] setSelected:YES];
                              
                              [(UIButton *)[weakSelf.selectedButton viewWithTag:kActionImageTag] setImage:[UIImage imageNamed:@"bt_minus_photo"] forState:UIControlStateHighlighted | UIControlStateSelected];
                              
                              [weakSelf checkVisibilityOfFirstActionButton];
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatar" object:nil];
                              
                              [hudView completeAndDismissWithTitle:NSLocalizedString(@"Success", nil)];
                          }
                          else {
                              [hudView failAndDismissWithTitle:NSLocalizedString(@"Failed", nil)];
                          }
                      }];
                 }
                 else {
                      [hudView failAndDismissWithTitle:NSLocalizedString(@"Failed", nil)];
                 }
              }];
         }
         else {
             [hudView failAndDismissWithTitle:NSLocalizedString(@"Failed", nil)];
         }
     }];
}

- (void)checkVisibilityOfFirstActionButton {
    if([self indexOfLastDraggableButtonWithImage] == 0) {
        [self.buttons[0] viewWithTag:kActionImageTag].hidden = YES;
    }
    else {
        [self.buttons[0] viewWithTag:kActionImageTag].hidden = NO;
    }
}

- (void)deleteImage:(UIView *)view {
    DTADraggableImagesButton* btn = (DTADraggableImagesButton *)view.superview;
    
    if(btn.imageId) {
        NSLog(@"delete");
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want delete this image?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        [errorAlert show];
        
        self.indexOfViewForRemove = [self.buttons indexOfObject:btn];
    }
    else {
        self.selectedButton = [self draggableButtonForAddingImage];
        [self.delegate pressAddImageButton];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    __weak typeof(self) weakSelf = self;
    
    if(buttonIndex == 0) {
        [DTAAPI deleteProfileImageForId:((DTADraggableImagesButton *)self.buttons[self.indexOfViewForRemove]).imageId WithCompletion:^(NSError *error) {
             if(!error) {
                 [weakSelf shiftImages];
                 
                 DTADraggableImagesButton *btn = self.buttons[[weakSelf indexOfLastDraggableButtonWithImage]];
                 
                 [(UIButton *)[btn viewWithTag:kActionImageTag] setSelected:NO];
                
                 [(UIButton *)[btn viewWithTag:kActionImageTag] setImage:[UIImage imageNamed:@"bt_plus_photo"] forState:UIControlStateHighlighted | UIControlStateNormal];
                 
                 [btn setImage:nil forState:UIControlStateNormal];
                 
                 [weakSelf.imageViews[[weakSelf.buttons indexOfObject:btn]] setImage:[UIImage imageNamed:@"avatar_ph"]];
                 
                 [weakSelf.imageViews[[weakSelf.buttons indexOfObject:btn]] setContentMode:UIViewContentModeCenter];
                 
                 [btn setImageId:nil];
                 
                 [weakSelf checkVisibilityOfFirstActionButton];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAvatar" object:nil];
                 
                 NSMutableArray *idsArray = [NSMutableArray array];
                 
                 for(DTADraggableImagesButton *button in weakSelf.buttons) {
                     if(button.imageId) {
                         [idsArray addObject:button.imageId];
                     }
                 }
                 
                 [DTAAPI setImagesOrder:idsArray withCompletion:nil];
             }
         }];
    }
}

- (void)swapView:(UIImageView *)view withDraggableView:(DTADraggableImagesButton *)draggableView {
    __weak typeof(self) weakSelf = self;
    
    UIImageView *draggableImgView = (UIImageView *)self.imageViews[[self.buttons indexOfObject:draggableView]];
    
    DTADraggableImagesButton *viewButton = self.buttons[[self.imageViews indexOfObject:view]];
    
    UIImageView *firstAnimationImgView = [[UIImageView alloc] initWithImage:view.image];
    
    UIImageView *secondAnimationImgView = [[UIImageView alloc] initWithImage:draggableImgView.image];
    
    [firstAnimationImgView setContentMode:UIViewContentModeScaleAspectFill];
    [secondAnimationImgView setContentMode:UIViewContentModeScaleAspectFill];
    
    firstAnimationImgView.frame = view.frame;
    secondAnimationImgView.frame = draggableImgView.frame;
    
    firstAnimationImgView.clipsToBounds = YES;
    secondAnimationImgView.clipsToBounds = YES;
    
    [self addSubview:firstAnimationImgView];
    [self addSubview:secondAnimationImgView];
    
    CGRect supRect = firstAnimationImgView.frame;
    
    [viewButton setImage:nil forState:UIControlStateNormal];
    [draggableView setImage:nil forState:UIControlStateNormal];
    
    [draggableImgView setImage:[UIImage imageNamed:@"avatar_ph"]];
    [view setImage:[UIImage imageNamed:@"avatar_ph"]];
    
    [draggableImgView setContentMode:UIViewContentModeCenter];
    [view setContentMode:UIViewContentModeCenter];
    
    [self removeBorderFromView:draggableView];
    
    [UIView animateWithDuration:0.3 animations:^{
         firstAnimationImgView.frame = secondAnimationImgView.frame;
         secondAnimationImgView.frame = supRect;
         
     } completion:^(BOOL finished) {
         [view setContentMode:UIViewContentModeScaleAspectFill];
         [draggableImgView setContentMode:UIViewContentModeScaleAspectFill];
         
         view.image = secondAnimationImgView.image;
         draggableImgView.image = firstAnimationImgView.image;
         
         [draggableView setImage:firstAnimationImgView.image forState:UIControlStateNormal];
         [viewButton setImage:secondAnimationImgView.image forState:UIControlStateNormal];
         
         [firstAnimationImgView removeFromSuperview];
         [secondAnimationImgView removeFromSuperview];
         
         NSString *supImageId = draggableView.imageId;
         draggableView.imageId = viewButton.imageId;
         viewButton.imageId = supImageId;
         
         [weakSelf showActionButtons];
         
         [weakSelf setAvatarImageFromView:viewButton];
         
         NSMutableArray *idsArray = [NSMutableArray array];
         
         for(DTADraggableImagesButton *button in weakSelf.buttons) {
             if(button.imageId) {
                 [idsArray addObject:button.imageId];
             }
         }
         
         [DTAAPI setImagesOrder:idsArray withCompletion:nil];
     }];
}

- (void)addBorderToView:(UIView *)view {
    view.layer.zPosition = 1;
    view.layer.borderColor = [UIColor colorWithRed:0.96 green:0.8 blue:0.34 alpha:1].CGColor;
    view.layer.borderWidth = 1.0f;
    view.alpha = 0.6f;
}

- (void)removeBorderFromView:(UIView *)view {
    view.layer.zPosition = 0;
    view.layer.borderWidth = 0.0;
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.alpha = 1.0f;
}

- (UIImageView *)viewForSwappingForView:(UIView *)draggableView touchPoint:(CGPoint)touchPoint {
    UIImageView *viewForSwapping = nil;
    
    for(UIImageView *view in self.subviews) {
        if(draggableView.tag != view.tag && view.tag && view.tag != kActionImageTag) {
            if([view isKindOfClass:[UIImageView class]]) {
                if(CGRectContainsPoint(view.frame, touchPoint) && [view image]) {
                    if(![[view image] isEqual:[UIImage imageNamed:@"avatar_ph"]] && view.tag != [self.imageViews[[self.buttons indexOfObject:draggableView]] tag]) {
                        return view;
                    }
                }
            }
        }
    }
    
    return viewForSwapping;
}

#pragma mark - Touch methods

- (void)touchDown:(UIView *)sender withEvent:(UIEvent *)event {
    if([(UIButton *)sender imageForState:UIControlStateNormal]) {
        self.isImageCanBeDragged = YES;
        self.initialPositionOfDraggableView = sender.center;
        [self hideActionButtons];
        [self addBorderToView:sender];
    }
    else {
        self.isImageCanBeDragged = NO;
    }
}

- (void)touchUp:(DTADraggableImagesButton *)sender withEvent:(UIEvent *)event {
    if(self.isImageCanBeDragged) {
        __weak typeof(self) weakSelf = self;
        
        UITouch *t = [[event allTouches] anyObject];
        CGPoint p = [t locationInView:self];
        
        UIImageView *viewForSwapping = [self viewForSwappingForView:sender touchPoint:p];
        
        if(viewForSwapping) {
            [self swapView:viewForSwapping withDraggableView:sender];
        }
        else {
            [UIView animateWithDuration:0.3f animations:^{
                 sender.center = weakSelf.initialPositionOfDraggableView;
                 [weakSelf removeBorderFromView:sender];
                 
             } completion:^(BOOL finished) {
                [weakSelf showActionButtons];
            }];
        }
        
    }
}

- (void)imageMoved:(id) sender withEvent:(UIEvent *) event {
    if(self.isImageCanBeDragged) {
        UIControl *control = sender;
        
        UITouch *t = [[event allTouches] anyObject];
        CGPoint pPrev = [t previousLocationInView:control];
        CGPoint p = [t locationInView:control];
        
        CGPoint center = control.center;
        center.x += p.x - pPrev.x;
        center.y += p.y - pPrev.y;
        control.center = center;
    }
}

@end
