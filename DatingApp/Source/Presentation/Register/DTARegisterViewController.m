//
//  DTARegisterViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTARegisterViewController.h"
#import "DTATermsConditionsViewController.h"
#import "DTAPrivacyPolicyViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User+Extension.h"
#import "Session+Extensions.h"
#import "DTATextField.h"
#import "NSString+Email.h"
#import "DTAEditProfileViewController.h"
#import "User.h"
#import "DTASocket.h"
#import "InstagramViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>


static NSUInteger kMinPasswordLength = 8;
static CGFloat kPolicyTemrsFontSize = 12.0f;

API_AVAILABLE(ios(13.0))
@interface DTARegisterViewController () <UITextFieldDelegate, InstagramViewControllerDelegate,ASAuthorizationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonSignUp;

@property (weak, nonatomic) IBOutlet UILabel *labelSignUpWithFB;
@property (weak, nonatomic) IBOutlet UILabel *labelOR;
@property (weak, nonatomic) IBOutlet UILabel *labelTransition;
@property (weak, nonatomic) IBOutlet UIView *agreeTextContainerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageExternalFB;
@property (weak, nonatomic) IBOutlet UIImageView *imageInternalFB;

@property (weak, nonatomic) IBOutlet UIImageView *imageExternalInstagram;
@property (weak, nonatomic) IBOutlet UIImageView *imageInternalInstagram;

@property (weak, nonatomic) IBOutlet UIImageView *imageExternalApple;
@property (weak, nonatomic) IBOutlet UIImageView *imageInternalApple;

@property (nonatomic, strong) NSString *token;

@property (weak, nonatomic) IBOutlet DTATextField *fieldEmail;
@property (weak, nonatomic) IBOutlet DTATextField *fieldPassword;
@property (weak, nonatomic) IBOutlet DTATextField *fieldConfirmPassword;

- (IBAction)actionToLoginVC:(id)sender;
- (IBAction)actionSignUp:(id)sender;
- (IBAction)actionTapFacebook:(id)sender;
- (IBAction)actionTapApple:(id)sender;
- (IBAction)actionTapInstagram:(id)sender;
- (IBAction)tapOutside:(id)sender;
- (IBAction)actionToTermsConditions:(id)sender;
@property (strong, nonatomic) IBOutlet ASAuthorizationAppleIDButton *btnAppleSignIn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageToluDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonFacebookDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelSingUpWithFBDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelORDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewFieldDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintButtonSignupDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLabelTranstionDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintContainerViewAgreeTextDistanceToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollViewDistanceToBottom;

@end

@implementation DTARegisterViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //--- setup ui
    CGFloat coefficient = [UIScreen mainScreen].bounds.size.width / 320;
    
    self.constraintImageToluDistanceToTop.constant *= coefficient;
    self.constraintButtonFacebookDistanceToTop.constant *= coefficient;
    self.constraintLabelSingUpWithFBDistanceToTop.constant *= coefficient;
    self.constraintLabelORDistanceToTop.constant *= coefficient;
    self.constraintViewFieldDistanceToTop.constant *= coefficient;
    self.constraintButtonSignupDistanceToTop.constant *= coefficient;
    self.constraintLabelTranstionDistanceToTop.constant *= coefficient;
    self.constraintContainerViewAgreeTextDistanceToTop.constant *= coefficient;
    
    [self.view layoutIfNeeded];
    
    self.imageExternalFB.layer.cornerRadius = self.imageExternalFB.layer.bounds.size.height / 2;
    self.imageInternalFB.layer.cornerRadius = self.imageInternalFB.layer.bounds.size.height / 2;
    
    self.imageExternalInstagram.layer.cornerRadius = self.imageExternalInstagram.layer.bounds.size.height / 2;
    self.imageInternalInstagram.layer.cornerRadius = self.imageInternalInstagram.layer.bounds.size.height / 2;
    
    self.imageExternalApple.layer.cornerRadius = self.imageExternalApple.layer.bounds.size.height / 2;
    self.imageInternalApple.layer.cornerRadius = self.imageInternalApple.layer.bounds.size.height / 2;
    
    self.buttonSignUp.layer.cornerRadius = self.buttonSignUp.layer.bounds.size.height / 2;
    [self.buttonSignUp.titleLabel setFont:[UIFont fontWithName:self.buttonSignUp.titleLabel.font.fontName size:self.buttonSignUp.titleLabel.font.pointSize * scaleCoefficient]];
    
    [self.fieldEmail setupLeftViewWithImageNamed:@"ico_email"];
    [self.fieldPassword setupLeftViewWithImageNamed:@"ico_pwd"];
    [self.fieldConfirmPassword setupLeftViewWithImageNamed:@"ico_pwd"];
    
    self.fieldEmail.font = [UIFont fontWithName:self.fieldEmail.font.fontName size:self.fieldEmail.font.pointSize * coefficient];
    
    self.fieldPassword.font = [UIFont fontWithName:self.fieldPassword.font.fontName size:self.fieldPassword.font.pointSize * coefficient];
    
    self.fieldConfirmPassword.font = [UIFont fontWithName:self.fieldConfirmPassword.font.fontName size:self.fieldConfirmPassword.font.pointSize * coefficient];
    
    self.fieldEmail.rightViewMode =  UITextFieldViewModeAlways;
    self.fieldPassword.rightViewMode =  UITextFieldViewModeAlways;
    self.fieldConfirmPassword.rightViewMode =  UITextFieldViewModeAlways;
    
    NSMutableAttributedString *attrText;
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.labelSignUpWithFB.attributedText];
    
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.labelSignUpWithFB.font.fontName size:self.labelSignUpWithFB.font.pointSize * coefficient] range:NSMakeRange(0, attrText.length)];
    
    [self.labelSignUpWithFB setAttributedText:attrText];
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.labelOR.attributedText];
   
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.labelOR.font.fontName size:self.labelOR.font.pointSize * coefficient] range:NSMakeRange(0, attrText.length)];
    
    [self.labelOR setAttributedText:attrText];
    
    NSArray *items = [self.labelTransition.text componentsSeparatedByString:@"?"];
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.labelTransition.attributedText];
    
    [attrText addAttribute:NSForegroundColorAttributeName value:colorDenim range:NSMakeRange([items[0] length] +1, [items[1] length])];
 
    [attrText addAttribute:NSForegroundColorAttributeName value:colorStarDust range:NSMakeRange(0, [items[0] length] +1)];
    
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.labelTransition.font.fontName size:self.labelTransition.font.pointSize * coefficient] range:NSMakeRange(0, attrText.length)];
    
    [self.labelTransition setAttributedText: attrText];
    
    [self buildAgreeTextViewFromString:NSLocalizedString(@"By signing up with #Facebook, #Instagram #or #Email # you #agree #to #our #<pp>Privacy Policy# and #<ts>Terms of use#", @"PLEASE NOTE: please translate \"terms of service\" and \"privacy policy\" as well, and leave the #<ts># and #<pp># around your translations just as in the English version of this message.")];
    
    if ([self.isTokenExpired isEqualToString:@"1"]) {
        
    }
    else {
        __weak typeof(self) weakSelf = self;
        if ([User currentUser].session.accessToken.length) {
        
            if(![User currentUser].relationship) {
            
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        
                if(![ud objectForKey:@"Logout"]) {
                    [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                    [ud setObject:@NO forKey:@"Logout"];
                    [ud synchronize];
                }
                else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if([User currentUser].session.accessToken.length > 0) {
        [[DTASocket sharedInstance] connectWebSocketWithTocken:[User currentUser].session.accessToken];
    }
}

#pragma mark - IBActions

- (IBAction)actionToLoginVC:(id)sender  {
    [self performSegueWithIdentifier:toLoginVC sender:self];
}

- (IBAction)actionSignUp:(id)sender {
    
    if (!IS_HOST_REACHABLE) {
        [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
    }
    else {
        NSString *email    = self.fieldEmail.text;
        NSString *password = self.fieldPassword.text;
        NSString *confirmPass = self.fieldConfirmPassword.text;
        
        BOOL error = NO;
        
        if(!error && ![email isEmailValid]) {
            [self showAlertController:NSLocalizedString(@"Wrong email", nil) andMessage:NSLocalizedString(@"Please input properly e-mail", nil)];
            error = YES;
        }
        
        if(!error && [password length] < kMinPasswordLength) {
            [self showAlertController:NSLocalizedString(@"Password", nil) andMessage:NSLocalizedString(@"Password should be at least 8 symbols", nil)];
            error = YES;
        }
        
        if(!error && ![password isEqualToString:confirmPass]) {
            [self showAlertController:NSLocalizedString(@"Password", nil) andMessage:NSLocalizedString(@"Password conformation failed. Please try again", nil)];
            self.fieldPassword.text = @"";
            self.fieldConfirmPassword.text = @"";
            error = YES;
        }
        
        if(!error) {
            APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
            [APP_DELEGATE.hud show];
            
            __weak typeof (self) weakSelf = self;
            [DTAAPI registerViaEmail:self.fieldEmail.text password:self.fieldPassword.text completion:^(NSError *error) {
                 if (!error) {
                     [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                 }
                 else {
                     [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                 }
                 
                 [APP_DELEGATE.hud dismiss];
             }];
        }
    }
}
- (IBAction)actionTapFacebook:(id)sender {
    
    if (!IS_HOST_REACHABLE) {
        [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
    }
    else {
        
        __weak typeof(self) weakSelf = self;
    
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logOut];
//        @"user_photos"
        [login logInWithPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
            
            if (error) {
                [self showAlertController:@"Facebook" andMessage:@"Facebook login error"];
            }
            else if (result.isCancelled) {
                [self showAlertController:@"Facebook" andMessage:@"Facebook login canceled"];
            }
            else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]) {
                    [weakSelf loginViaFacebookWithResult:result];
                }
            }
        }];
        
//        [login logInWithReadPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//
//             if (error) {
//                 [self showAlertController:@"Facebook" andMessage:@"Facebook login error"];
//             }
//             else if (result.isCancelled) {
//                 [self showAlertController:@"Facebook" andMessage:@"Facebook login canceled"];
//             }
//             else {
//                 // If you ask for multiple permissions at once, you
//                 // should check if specific permissions missing
//                 if ([result.grantedPermissions containsObject:@"email"] && [result.grantedPermissions containsObject:@"public_profile"]) {
//                     [weakSelf loginViaFacebookWithResult:result];
//                 }
//             }
//         }];
    }
}
- (IBAction)actionTapApple:(id)sender {
    
    if (!IS_HOST_REACHABLE) {
        [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
    }
    else {
        
        __weak typeof(self) weakSelf = self;
    
        if (@available(iOS 13.0, *)) {
            ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
            
            ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
            request.requestedScopes  = [[NSArray alloc] initWithObjects:ASAuthorizationScopeFullName,ASAuthorizationScopeEmail, nil];
            ASAuthorizationController *authController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
            authController.delegate =  self;
            [authController performRequests];
            
        } else {
            // Fallback on earlier versions
        }
        
    }
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(nonnull ASAuthorization *)authorization API_AVAILABLE(ios(13.0)) {
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
    NSString *userIdentifier = appleIDCredential.user;
    NSPersonNameComponents *fullName = appleIDCredential.fullName;
    NSString *email = appleIDCredential.email == NULL ? @"" : appleIDCredential.email ;
    app.userIdentifierApple = userIdentifier;
    

    NSString *firstName = fullName.givenName == NULL ? @"" : fullName.givenName ;
    NSString *middleName = fullName.middleName == NULL ? @"" : fullName.middleName ;
    NSString *lastName = fullName.familyName == NULL ? @"" : fullName.familyName ;
    
    NSString *finalName  = [NSString stringWithFormat:@"%@ %@ %@", firstName,middleName,lastName];
    
    NSMutableDictionary *appleDict = [[NSMutableDictionary alloc]initWithObjectsAndKeys:email,@"email",userIdentifier,@"social_id",@"appleSignIn",@"social_type",finalName,@"name",@"",@"image",nil];
    
    
    [self SignupUsingApple:appleDict];


}
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)) {
    [self showAlertController:@"Error" andMessage:error.description];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTapInstagram:(id)sender {

    InstagramViewController *vc = [[InstagramViewController alloc] init];
    
    // f8479dadbb674de591b53f700a70aeef - c o
    // a6ce330d9c434c958c6852fb41f4bdba - c
    
    vc.authString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@", @"https://api.instagram.com/oauth/authorize/", @"f8479dadbb674de591b53f700a70aeef", @"https://www.konstantinfo.com/", @"basic"];
    
//     vc.authString = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@", @"https://api.instagram.com/oauth/authorize/", @"719086688661473", @"https://www.konstantinfo.com/", @"basic"];
    
    vc.delegate = self;
        
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)getInstagramLoginToken:(NSString *)accessToken {
    
    if ([accessToken isEqualToString:@""]) {
        
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:@"instaAuthToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [self getInstagramLoginData];
    }
}

- (void) getInstagramLoginData {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    NSString *userInfoURL = [NSString stringWithFormat:@"%@?access_token=%@", @"https://api.instagram.com/v1/users/self/", [[NSUserDefaults standardUserDefaults] objectForKey:@"instaAuthToken"]];
    NSLog(@"userInfoURL = %@", userInfoURL);
    
    NSURL *url = [NSURL URLWithString:userInfoURL];
    
    __weak typeof (self) weakSelf = self;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"json = %@", json);
            
            NSDictionary *data = [json objectForKey:@"data"];
            NSString *instaId = [data objectForKey:@"id"];
            
            [APP_DELEGATE.hud dismiss];
            
            [weakSelf loginViaInstagramWithInstagramID:instaId];
        }
        else {
            [APP_DELEGATE.hud dismiss];
            NSLog(@"error getData = %@", error.localizedDescription);
            [weakSelf showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
        }
    }];
    
    [task resume];
}

- (IBAction)tapOutside:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionToTermsConditions:(id)sender {
    [self performSegueWithIdentifier:toTermsConditionsVC sender:self];
}

#pragma mark - UItextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.fieldEmail) {
        [self.fieldPassword becomeFirstResponder];
    }
    else if (textField == self.fieldPassword) {
        [self.fieldConfirmPassword becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self actionSignUp:self];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    
    self.fieldEmail.backgroundColor = [UIColor clearColor];
    self.fieldPassword.backgroundColor = [UIColor clearColor];
    self.fieldConfirmPassword.backgroundColor = [UIColor clearColor];
    
    textField.backgroundColor = colorOrangeWhite;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.fieldEmail) {
        if ([text isEmailValid]) {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_ok_y"]];
        }
        else {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_del_g"]];
        }
    }
    
    if (textField == self.fieldPassword) {
        if ([text length] < kMinPasswordLength) {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_del_g"]];
        }
        else {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_ok_y"]];
        }
    }
    
    if (textField == self.fieldConfirmPassword) {
        if ([text isEqualToString: self.fieldPassword.text]) {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_ok_y"]];
        }
        else {
            textField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bt_del_g"]];
        }
    }
    
    return YES;
}

#pragma mark - Notifications

- (void)keyboardDidShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.constraintScrollViewDistanceToBottom.constant = keyboardSize.height;
    [self.view layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.constraintScrollViewDistanceToBottom.constant = 0;
    [self.view layoutIfNeeded];
}

#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender; {
    if ([segue.identifier isEqualToString:pushEditProfileViewControllerSegue]) {
        self.fieldEmail.text = @"";
        self.fieldPassword.text = @"";
        self.fieldConfirmPassword.text = @"";
        
        ((DTAEditProfileViewController *)segue.destinationViewController).isFromRegisterVC = YES;
    }
}

#pragma mark - Procedures

- (void)SignupUsingApple:(NSMutableDictionary *)result {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
   
    __weak typeof (self) weakSelf = self;
    
//    NSString *idStr = result[@"social_id"];
    
    [DTAAPI loginViaApple:result completion:^(NSError *error, NSArray *resultArr) {

        if (!error) {

            User *user = resultArr.firstObject;

            if (user.isFull) {
                [weakSelf dismissViewControllerAnimated:YES completion:^ {

                }];
            }
            else {
                [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
            }

            [APP_DELEGATE.hud dismiss];
        }
        else if (error.code == 401) {

            [DTAAPI registerViaAppleToken:result completion:^(NSError *error) {

                 if (!error) {
                     [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                 }
                 else {
                     [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                 }

                 [APP_DELEGATE.hud dismiss];
             }];
        }
        else {
            [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
            [APP_DELEGATE.hud dismiss];
        }
    }];
}

- (void)loginViaFacebookWithResult:(FBSDKLoginManagerLoginResult *)result {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
   
    self.token = result.token.tokenString;
    __weak typeof (self) weakSelf = self;
    
    [DTAAPI loginViaFacebookToken:result.token.tokenString completion:^(NSError *error, NSArray *result) {
        
        if (!error) {
            
            User *user = result.firstObject;
     
            if (user.isFull) {
                [weakSelf dismissViewControllerAnimated:YES completion:^ {
                    
                }];
            }
            else {
                [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
            }
            
            [APP_DELEGATE.hud dismiss];
        }
        else if (error.code == 401) {
            
            [DTAAPI registerViaFacebookToken:self.token completion:^(NSError *error) {
                
                 if (!error) {
                     [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                 }
                 else {
                     [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                 }
                 
                 [APP_DELEGATE.hud dismiss];
             }];
        }
        else {
            [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
            [APP_DELEGATE.hud dismiss];
        }
    }];
}

- (void)loginViaInstagramWithInstagramID: (NSString *) instagramID {
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    __weak typeof (self) weakSelf = self;
    
    [DTAAPI loginViaInstagramToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"instaAuthToken"] completion:^(NSError *error, NSArray *result) {
        
        if (!error) {
            
            User *user = result.firstObject;
            
            if (user.isFull) {
                [weakSelf dismissViewControllerAnimated:YES completion:^ {
                    
                }];
            }
            else {
                [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
            }
            
            [APP_DELEGATE.hud dismiss];
        }
        else if (error.code == 401) {
            
            [DTAAPI registerViaInstagramToken: [[NSUserDefaults standardUserDefaults] objectForKey:@"instaAuthToken"] andInstagramId:instagramID completion:^(NSError *error) {
                
                [APP_DELEGATE.hud dismiss];
                
                if (!error) {
                    [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                }
                else {
                    [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                }
                
                [APP_DELEGATE.hud dismiss];
            }];
        }
        else {
            [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
            [APP_DELEGATE.hud dismiss];
        }
    }];
}

- (void) showAlertController: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)buildAgreeTextViewFromString:(NSString *)localizedString {
    
    // 1. Split the localized string on the # sign:
    NSArray *localizedStringPieces = [localizedString componentsSeparatedByString:@"#"];
    
    // 2. Loop through all the pieces:
    NSUInteger msgChunkCount = localizedStringPieces ? localizedStringPieces.count : 0;
   
    CGPoint wordLocation = CGPointMake(0.0, 0.0);
    
    for (NSUInteger i = 0; i < msgChunkCount; i++) {
        NSString *chunk = [localizedStringPieces objectAtIndex:i];
    
        if ([chunk isEqualToString:@""]) {
            continue;
            // skip this loop if the chunk is empty
        }
        
        // 3. Determine what type of word this is:
        BOOL isTermsOfServiceLink = [chunk hasPrefix:@"<ts>"];
        BOOL isPrivacyPolicyLink  = [chunk hasPrefix:@"<pp>"];
        BOOL isLink = (BOOL)(isTermsOfServiceLink || isPrivacyPolicyLink);
        
        // 4. Create label, styling dependent on whether it's a link:
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:kPolicyTemrsFontSize * scaleCoefficient];
        label.text = chunk;
        label.userInteractionEnabled = isLink;
        
        if (isLink) {
            label.textColor = colorDenim;
            label.highlightedTextColor = [UIColor yellowColor];
            
            // 5. Set tap gesture for this clickable text:
            SEL selectorAction = isTermsOfServiceLink ? @selector(tapOnTermsOfServiceLink:) : @selector(tapOnPrivacyPolicyLink:);
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:selectorAction];
            
            [label addGestureRecognizer:tapGesture];
            
            // Trim the markup characters from the label:
            if (isTermsOfServiceLink) {
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<ts>" withString:@""];
            }
            
            if (isPrivacyPolicyLink) {
                label.text = [label.text stringByReplacingOccurrencesOfString:@"<pp>" withString:@""];
            }
        }
        else {
            label.textColor = colorStarDust;
        }
        
        // 6. Lay out the labels so it forms a complete sentence again:
        
        // If this word doesn't fit at end of this line, then move it to the next
        // line and make sure any leading spaces are stripped off so it aligns nicely:
        
        [label sizeToFit];
        
        if (self.agreeTextContainerView.frame.size.width < wordLocation.x + label.bounds.size.width) {
            wordLocation.x = 0.0;                       // move this word all the way to the left...
            wordLocation.y += label.frame.size.height;  // ...on the next line
            
            // And trim of any leading white space:
            NSRange startingWhiteSpaceRange = [label.text rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
            
            if (startingWhiteSpaceRange.location == 0) {
                label.text = [label.text stringByReplacingCharactersInRange:startingWhiteSpaceRange withString:@""];
                [label sizeToFit];
            }
        }
        
        // Set the location for this label:
        label.frame = CGRectMake(wordLocation.x, wordLocation.y, label.frame.size.width, label.frame.size.height);
        
        // Show this label:
        [self.agreeTextContainerView addSubview:label];
        
        // Update the horizontal position for the next word:
        wordLocation.x += label.frame.size.width;
    }
}

- (void)tapOnTermsOfServiceLink:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        DTATermsConditionsViewController *termsVC = [self.storyboard instantiateViewControllerWithIdentifier:DTATermsConditionsViewControllerID];
        [self.navigationController pushViewController:termsVC animated:YES];
    }
}

- (void)tapOnPrivacyPolicyLink:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        DTAPrivacyPolicyViewController *privacyVC = [self.storyboard instantiateViewControllerWithIdentifier:DTAPrivacyPolicyViewControllerID];
        [self.navigationController pushViewController:privacyVC animated:YES];
    }
}

#pragma mark -

@end
