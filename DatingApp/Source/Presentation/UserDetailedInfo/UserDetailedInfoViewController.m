//
//  UserDetailedInfoViewController.m
//  DatingApp
//
//  Created by  Artem Kalinovsky on 9/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "UserDetailedInfoViewController.h"
#import "DTAChatViewController.h"
#import "User.h"
#import "User+Extension.h"
#import "Relationship+Extensions.h"
#import "Country+Extensions.h"
#import "Education.h"
#import "Religion+Extensions.h"
#import "Ethnic.h"
#import "Profession+Extensions.h"
#import "DTAImageViewController.h"
#import "NSString+Email.h"
#import "DTASwipeImages.h"
#import "DTAReportView.h"
#import "SubscriptionVC.h"
#import "Goals.h"
#import "WantKids.h"
#import "HaveKids.h"
#import "Orientation.h"


@interface UserDetailedInfoViewController () <UIScrollViewDelegate, DTAReportViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameAndAgeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personalStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ethnicGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *professionLabel;
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryOfOriginLabel;
@property (weak, nonatomic) IBOutlet UILabel *religionLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *userPhotosCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *milesFromYouLabel;

@property (strong, nonatomic) IBOutlet UILabel *goalLabel;
@property (strong, nonatomic) IBOutlet UILabel *wantKidsLabel;
@property (strong, nonatomic) IBOutlet UILabel *haveKidsLabel;
@property (strong, nonatomic) IBOutlet UILabel *orientationLabel;


//What are your 5 favorite things
@property (weak, nonatomic) IBOutlet UILabel *favThingLabel;
@property (weak, nonatomic) IBOutlet UILabel *favThingValue;

//What is your favorite jollof?
@property (weak, nonatomic) IBOutlet UILabel *favJollLabel;
@property (weak, nonatomic) IBOutlet UILabel *favJollValue;

//What brings you joy?
@property (weak, nonatomic) IBOutlet UILabel *joyLabel;
@property (weak, nonatomic) IBOutlet UILabel *joyValue;

//Parent dreams for you? Doctor, Lawyer or Engineer?
@property (weak, nonatomic) IBOutlet UILabel *dreamParentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamParentValue;

@property (weak, nonatomic) IBOutlet DTASwipeImages *swipeImages;
@property (strong, nonatomic) DTAReportView *reportView;

@property (nonatomic, assign) CGFloat lastPosition;
@property (nonatomic, assign) CGFloat totalHeigh;
@property (nonatomic, assign) CGFloat startOffset;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic, weak) IBOutlet UIScrollView *rootScroll;
@property (nonatomic, assign) BOOL startAnimation;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *dislakeButton;
@property (nonatomic, weak) IBOutlet UIButton *browseChatButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *actionButtonsTopSpacingConstraint;

- (IBAction)actionReportButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *morebutton;

@end

@implementation UserDetailedInfoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.swipeImages addImages:[self.detailedUser.image allObjects] animated:NO];
    [self setupBackButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.rootScroll.delegate = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.rootScroll.delegate = self;

    self.startOffset = self.rootScroll.contentOffset.y;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // DEV
    if ([User currentUser].userId) {
        [DTAAPI getUserSubscriptonStaus:[User currentUser].userId completion:^(NSError *error, NSArray *dataArr) {
            if (!error) {
            }
        }];
    }
    self.likeButton.hidden = self.hideButtons & DTAButtonsHideStateLike;
    self.browseChatButton.hidden = self.hideButtons & DTAButtonsHideStateChat;
    self.dislakeButton.hidden = self.hideButtons & DTAButtonsHideStateDislike;
    
    if (self.likeButton.hidden && self.dislakeButton.hidden && self.browseChatButton.hidden) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem = nil;
    }
    else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem = self.morebutton;
    }
    
    NSString *name = [NSString stringWithFormat:@"%@, %li", self.detailedUser.firstName, (long) self.detailedUser.userAge];
    
//    NSString *location = [NSString stringWithFormat:@"(%@)", [self.detailedUser fetchCityNameFromLocation]];
    NSString *location = [NSString stringWithFormat:@"%@", [self.detailedUser fetchCityNameFromLocation]];
    if ([self.detailedUser fetchCityNameFromLocation].length > 0) {
        location = [NSString stringWithFormat:@"(%@)", [self.detailedUser fetchCityNameFromLocation]];
    }
    self.nameAndAgeLabel.attributedText = [NSString generateStringFormName:name location:location];
    
    self.personalStatusLabel.text = self.detailedUser.relationship.relationshipTitle;
    
    self.educationLabel.text = self.detailedUser.education.educationTitle;
    
    self.religionLabel.text = self.detailedUser.religion.religionTitle;
    
    self.ethnicGroupLabel.text = self.detailedUser.ethnic.ethnicTitle;
    
    self.professionLabel.text = self.detailedUser.profession.professionTitle;
    
    self.countryOfOriginLabel.text = self.detailedUser.country.countryTitle;
    
    self.milesFromYouLabel.text = @"";
    
    /*
    if (self.detailedUser.distance) {
        self.milesFromYouLabel.text = [NSString stringWithFormat:@"%@ miles from you", self.detailedUser.distance];
    }
     */
    
    //DEV
    self.goalLabel.text = self.detailedUser.goals.goalTitle;
    self.wantKidsLabel.text = self.detailedUser.wantKids.wantKidsTitle;
    self.haveKidsLabel.text = self.detailedUser.haveKids.haveKidsTitle;
    self.orientationLabel.text = self.detailedUser.orientation.orientationTitle;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0.f;
        
    if (self.detailedUser.summary.length) {
        self.actionButtonsTopSpacingConstraint.constant = 20.0f;
        self.summaryLabel.hidden = NO;
        self.summaryTitleLbl.hidden = NO;
        
        self.summaryLabel.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.summary attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
    }
    else {
        self.actionButtonsTopSpacingConstraint.constant = -40.0f;
        self.summaryLabel.hidden = YES;
        self.summaryTitleLbl.hidden = YES;
    }
    
    if (self.detailedUser.favoriteThings.length) {
        self.favThingValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.favoriteThings attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favThingValue.hidden = NO;
        self.favThingLabel.hidden = NO;
    }
    else {
        self.favThingValue.hidden = YES;
        self.favThingLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.favoriteJoll.length) {
        self.favJollValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.favoriteJoll attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.favJollValue.hidden = NO;
        self.favJollLabel.hidden = NO;
    }
    else {
        self.favJollValue.hidden = YES;
        self.favJollLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.bringJoy.length) {
        self.joyValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.bringJoy attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.joyValue.hidden = NO;
        self.joyLabel.hidden = NO;
    }
    else {
        self.joyValue.hidden = YES;
        self.joyLabel.hidden = YES;
    }
    
    
    if (self.detailedUser.dreamParents.length) {
        self.dreamParentValue.attributedText = [[NSAttributedString alloc] initWithString:self.detailedUser.dreamParents attributes:@{NSParagraphStyleAttributeName : paragraphStyle}];
        
        self.dreamParentValue.hidden = NO;
        self.dreamParentLabel.hidden = NO;
    }
    else {
        self.dreamParentValue.hidden = YES;
        self.dreamParentLabel.hidden = YES;
    }
    
    [self.view layoutIfNeeded];
    
    self.userPhotosCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.detailedUser.image.count];
    self.totalHeigh = self.imageHeight.constant;
}
-(void)presentIAPView {
    SubscriptionVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionVC"];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark - IBActions

- (IBAction)pressChatButton:(id)sender {
    [self performSegueWithIdentifier:@"showChat" sender:self];
}

- (IBAction)tapOnBackBarButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapOnLikeButton:(UIButton *)sender {
    
//    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"matchCount"];
//    BOOL isSubsribed = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSubsribed"];
    
//    if (!isSubsribed) {
//        if (count <= 10) {
//            [self userLikeMethod];
//        }else {
//            [self presentIAPView];
//        }
//    }
//    else {
        [self userLikeMethod];
//    }
}
- (IBAction)tapOnDislikeButton:(UIButton *)sender {
    
//    NSInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:@"matchCount"];
//    BOOL isSubsribed = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSubsribed"];
    
//    if (!isSubsribed) {
//        if (count <= 10) {
//            [self userDisLikeMethod];
//        }else {
//            [self presentIAPView];
//        }
//    }
//    else {
        [self userDisLikeMethod];
//    }
}
-(void)userLikeMethod {
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    __weak typeof(self) weakSelf = self;
    
    [DTAAPI matchUser:self.detailedUser completion:^(NSError *error , NSArray *responseArr) {
        
        [APP_DELEGATE.hud dismiss];
        [[NSUserDefaults standardUserDefaults]setInteger:[[responseArr objectAtIndex:0]integerValue] forKey:@"matchCount"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        NSLog(@"matched count value in detail match user =====>> %@", responseArr);
        
        if (!error) {
            if([self.delegate respondsToSelector:@selector(selectUser:)]) {
                [self.delegate selectUser:self.detailedUser];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}
-(void)userDisLikeMethod {
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    __weak typeof(self) weakSelf = self;
    
    [DTAAPI deleteMatchForUser:self.detailedUser completion:^(NSError *error, NSArray *responseArr) {
        
        [[NSUserDefaults standardUserDefaults]setInteger:[[responseArr objectAtIndex:0]integerValue] forKey:@"matchCount"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [APP_DELEGATE.hud dismiss];
        
        if (!error) {
            if([self.delegate respondsToSelector:@selector(selectUser:)]) {
                [self.delegate selectUser:self.detailedUser];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}


- (IBAction)panGR:(UIPanGestureRecognizer *)gr {
    if (gr.state == UIGestureRecognizerStateBegan) {
        self.startAnimation = YES;
    
        //        NSLog(@"Begin");
        //        self.lastPosition = 0;
        //        [self.rootScroll scrollRectToVisible:CGRectZero animated:YES];
        //        [self.rootScroll setContentOffset:CGPointMake(0, -self.rootScroll.contentInset.top) animated:YES];
    }
    else if (gr.state == UIGestureRecognizerStateChanged) {
        // NSLog(@"%f", [gr velocityInView:self.view].y);
        // [self moveConstraintInImage:[gr translationInView:self.view].y];
    }
    else if (gr.state == UIGestureRecognizerStateEnded) {
        //[self moveToStartPosition];
    
        self.startAnimation = NO;
        [self moveToStartPosition];
        NSLog(@"End");
    }
}

- (IBAction)onUserProfilePhotoTap:(UITapGestureRecognizer *)sender {
    [self pressPhotoButton:nil];
}

- (IBAction)pressPhotoButton:(id)sender {
    [self performSegueWithIdentifier:@"presentImageViewController" sender:self];
}

- (IBAction)actionReportButtonPressed:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Sharing option:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *reportAction = [UIAlertAction actionWithTitle:@"Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (!self.reportView) {
            self.reportView = [DTAReportView showInView:self.view delegate:self];
        }
    }];
    
    [alertController addAction:reportAction];
    
    if (self.likeButton.isHidden == true && self.dislakeButton.isHidden == true) {
        UIAlertAction *blockAction = [UIAlertAction actionWithTitle:@"Block" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure to block this user?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
                [APP_DELEGATE.hud show];
                
                [DTAAPI blockMatchedUserWithUserId:self.detailedUser.userId andBlockedByUserId:[User currentUser].userId completion:^(NSError *error) {
                    
                    [APP_DELEGATE.hud completeAndDismissWithTitle:nil];
                    
                    if(!error) {
                        
                        
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else {
                        UIAlertController *newAlert = [UIAlertController alertControllerWithTitle:@"Block User Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okNewAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                        
                        [newAlert addAction:okNewAction];
                        
                        [self presentViewController:newAlert animated:YES completion:nil];
                    }
                }];
            }];
            
            [alert addAction:yesAction];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:noAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
        
        [alertController addAction:blockAction];
        
        UIAlertAction *unMatchAction = [UIAlertAction actionWithTitle:@"Unmatch" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You will be unmatched with this user" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
                [APP_DELEGATE.hud show];
                
                [DTAAPI removeUserFromMatchUserId:self.detailedUser.userId andCompletion:^(NSError *error, id result) {
                    
                    [APP_DELEGATE.hud completeAndDismissWithTitle:nil];
                    
                    if(!error) {
                        
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                    else {
                        UIAlertController *newAlert = [UIAlertController alertControllerWithTitle:@"Unmatch Error" message:nil preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *okNewAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
                        
                        [newAlert addAction:okNewAction];
                        
                        [self presentViewController:newAlert animated:YES completion:nil];
                    }
                }];
            }];
            
            [alert addAction:okAction];
            
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Cansel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [alert addAction:noAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];
        
        [alertController addAction:unMatchAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    
    [self.navigationController presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - ScrollViewDelegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.startAnimation) {
        // NSLog(@"%f", self.rootScroll.contentOffset.y);
        CGFloat y = self.rootScroll.contentOffset.y;
    
        if (self.startOffset > y) {
            self.imageHeight.constant += 3;
        }
        else if (self.startOffset < y && y >  self.lastPosition) {
            if (self.imageHeight.constant >= self.totalHeigh) {
                self.imageHeight.constant -= 3;
            }
        }
        
        self.lastPosition = y;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.startAnimation = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.startAnimation = NO;
    [self moveToStartPosition];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   /// [self moveToStartPosition];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   // [self moveToStartPosition];
}

#pragma mark - DTAReportView Delegate

- (void)proceedReportWithText:(NSString *)text image:(UIImage *)image {
    APP_DELEGATE.hud = [[SAMHUDView alloc] init];
    [APP_DELEGATE.hud show];
    
    __weak typeof(self) weakSelf = self;
    
    [DTAAPI reportUser:self.detailedUser reportText:text attachedImage:image completion:^(NSError *error) {
        if (!error) {
            [self.reportView dismissReportView];
            self.reportView = nil;
            
            [APP_DELEGATE.hud completeAndDismissWithTitle:nil];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"error" message:error.userInfo[@"message"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            
            [weakSelf presentViewController:alert animated:YES completion:nil];
            
            [APP_DELEGATE.hud dismiss];
        }
    }];
}

- (void)cancelButtonPressed:(id)sender {
    self.reportView = nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"presentImageViewController"]) {
        DTAImageViewController *destVC = segue.destinationViewController;
        destVC.imageArray = (NSArray *)self.detailedUser.image;
        destVC.startImageIndex = self.swipeImages.currentImageIndex;
    }
    else if ([segue.identifier isEqualToString:@"showChat"]) {
        //detailedUser
        DTAChatViewController *destVC = segue.destinationViewController;
        //DEV
        destVC.detailedUser = self.detailedUser;
        destVC.friendId = self.detailedUser.userId;
        destVC.titleString = [NSString stringWithFormat:@"%@, %li", self.detailedUser.firstName, (long) self.detailedUser.userAge];
    }
}

#pragma mark - Procedures

- (void)moveToStartPosition {
    if(self.imageHeight.constant != 328.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.imageHeight.constant = self.totalHeigh;
            [self.view layoutIfNeeded];
        }];
    }
}

- (void)backGroundMotion {
    CGFloat min = -20.0f;
    CGFloat max = 20.0f;
    
    // create the x axis motion
    UIInterpolatingMotionEffect *xAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    xAxis.minimumRelativeValue = @(min);
    xAxis.maximumRelativeValue = @(max);
    
    // create the y axis motion
    UIInterpolatingMotionEffect *yAxis = [[UIInterpolatingMotionEffect alloc]initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    yAxis.minimumRelativeValue = @(min);
    yAxis.maximumRelativeValue = @(max);
    
    // combine these is a group
    UIMotionEffectGroup *xyGroup = [[UIMotionEffectGroup alloc]init];
    xyGroup.motionEffects = @[xAxis, yAxis];
    
    //  apply what was created to the image
    //[self.userProfilePhotoImageView addMotionEffect:xyGroup];
}

@end
