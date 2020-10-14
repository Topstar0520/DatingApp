//
//  DTALoginViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTALoginViewController.h"
#import "DTATextField.h"
#import "NSString+Email.h"
#import "User+Extension.h"
#import "DTAEditProfileViewController.h"
#import "DTALocationManager.h"
#import "Session+Extensions.h"
#import "DTASocket.h"

@interface DTALoginViewController ()

@property (weak, nonatomic) IBOutlet DTATextField *fieldEmail;
@property (weak, nonatomic) IBOutlet DTATextField *fieldPassword;

@property (weak, nonatomic) IBOutlet UIButton *buttonLogin;
@property (weak, nonatomic) IBOutlet UIButton *buttonForgotPass;
@property (nonatomic, strong) DTALocationManager *manager;

- (IBAction)tapOutside:(id)sender;
- (IBAction)actionLogin:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintImageLogoWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLogoDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintFieldAuthDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLoginButtonDistanceToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintForgotButtonDistanceToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintScrollViewDistanceToBottom;

@end

@implementation DTALoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBarInvertWithTitle:@"Log In"];
    [self setupBackButtonInvert];
    
    //--- setup ui
    CGFloat coefficient = [UIScreen mainScreen].bounds.size.width / 320;
    self.constraintLogoDistanceToTop.constant *= coefficient;
    self.constraintFieldAuthDistanceToTop.constant *= coefficient;
    self.constraintLoginButtonDistanceToTop.constant *= coefficient;
    self.constraintForgotButtonDistanceToTop.constant *= coefficient;
    self.constraintImageLogoWidth.constant *= coefficient;
    
    [self.view layoutIfNeeded];
    
    self.buttonLogin.layer.cornerRadius = self.buttonLogin.layer.bounds.size.height / 2;
    [self.buttonLogin.titleLabel setFont:[UIFont fontWithName:self.buttonLogin.titleLabel.font.fontName size:self.buttonLogin.titleLabel.font.pointSize * coefficient]];
    
    [self.fieldEmail setupLeftViewWithImageNamed:@"ico_email"];
    [self.fieldPassword setupLeftViewWithImageNamed:@"ico_pwd"];
    self.fieldEmail.font = [UIFont fontWithName:self.fieldEmail.font.fontName size:self.fieldEmail.font.pointSize * coefficient];
    self.fieldPassword.font = [UIFont fontWithName:self.fieldPassword.font.fontName size:self.fieldPassword.font.pointSize * coefficient];
    
    NSMutableAttributedString *attrText;
    
    attrText = [[NSMutableAttributedString alloc] initWithAttributedString:self.buttonForgotPass.titleLabel.attributedText];
    
    [attrText addAttribute:NSFontAttributeName value:[UIFont fontWithName:self.buttonForgotPass.titleLabel.font.fontName size:self.buttonForgotPass.titleLabel.font.pointSize * coefficient] range:NSMakeRange(0, attrText.length)];
  
    [self.buttonForgotPass.titleLabel setAttributedText:attrText];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    self.manager = nil;
    self.manager = [DTALocationManager new];
    [self.manager trackLocationWithCompletionBlock:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - UItextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.fieldEmail) {
        [self.fieldPassword becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self actionLogin:self];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    self.fieldEmail.backgroundColor = [UIColor clearColor];
    self.fieldPassword.backgroundColor = [UIColor clearColor];
    textField.backgroundColor = colorOrangeWhite;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:pushEditProfileViewControllerSegue]) {
        ((DTAEditProfileViewController *)segue.destinationViewController).isFromRegisterVC = YES;
    }
}

#pragma mark - IBAction

- (IBAction)tapOutside:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)actionLogin:(id)sender {
    if (!IS_HOST_REACHABLE) {
        [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
    }
    else {
        NSString *email    = self.fieldEmail.text;
        NSString *password = self.fieldPassword.text;
        
        BOOL error = NO;
        
        if(!error && ![email isEmailValid]) {
            [self showAlertController:NSLocalizedString(@"Wrong email", nil) andMessage:NSLocalizedString(@"Please input properly e-mail", nil)];
            error = YES;
        }
        
        if(!error && ![password length]) {
            [self showAlertController:NSLocalizedString(@"Password", nil) andMessage:NSLocalizedString(@"Input password please", nil)];
            error = YES;
        }
        
        if (!error) {
            APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
            [APP_DELEGATE.hud show];
            
            __weak typeof (self) weakSelf = self;
           
            [DTAAPI loginViaEmail:self.fieldEmail.text password:self.fieldPassword.text completion:^(NSError *error, RKMappingResult *result) {
                
                 if (!error) {
//                     User *userObject = [result.dictionary valueForKey:@"user"];
//                     NSLog(@"%@", userObject.matchCount);
                     
//                     [[NSUserDefaults standardUserDefaults]setObject:userObject.matchCount forKey:@"matchCount"];
//                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                     if([User currentUser].session.accessToken.length > 0) {
                         [[DTASocket sharedInstance] connectWebSocketWithTocken:[User currentUser].session.accessToken];
                     }
                     
                     if([[User currentUser] isFull]) {
                         [weakSelf dismissViewControllerAnimated:YES completion:nil];
                     }
                     else {
                         [weakSelf performSegueWithIdentifier:pushEditProfileViewControllerSegue sender:weakSelf];
                     }
                 }
                 else {
                     [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                 }
                 
                 [APP_DELEGATE.hud dismiss];
             }];
        }
    }
}

- (void) showAlertController: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
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

#pragma mark -

@end
