//
//  DTAReportView.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 12/9/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAReportView.h"

static NSUInteger const DTAReportTextFieldMaxLength = 200;

@interface DTAReportView () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonReport;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) UIView *viewBackShadow;
@property (strong, nonatomic) UIImage *imageReport;

@property (strong, nonatomic) NSLayoutConstraint *constraintCenterY;

- (IBAction)actionPressReport:(id)sender;
- (IBAction)actionPressCancel:(id)sender;
- (IBAction)actionPressAddImg:(id)sender;

@end

@implementation DTAReportView

+ (DTAReportView *)showInView:(UIView *)parentView delegate:(id <DTAReportViewDelegate>)delegate {
    
    DTAReportView *reportView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DTAReportView class]) owner:nil options:nil] lastObject];
    reportView.viewBackShadow = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    reportView.viewBackShadow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.65];
    [parentView addSubview:reportView.viewBackShadow];
    
    if (delegate) {
        reportView.delegate = delegate;
    }
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:reportView action:@selector(tapAction)];
    [reportView.viewBackShadow addGestureRecognizer:tgr];
    
    [[NSNotificationCenter defaultCenter] addObserver:reportView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:reportView selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [parentView addSubview:reportView];
    [reportView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [reportView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[reportView(==280)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(reportView)]];
    
    [reportView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[reportView(==315)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(reportView)]];
    
    NSLayoutConstraint *constraintHorizontal = [NSLayoutConstraint constraintWithItem:reportView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f];
    
    NSLayoutConstraint *constraintVertical = [NSLayoutConstraint constraintWithItem:reportView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:parentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f];
    
    reportView.constraintCenterY = constraintVertical;
    [parentView addConstraints:@[constraintHorizontal, constraintVertical]];
    
    [reportView layoutSubviews];
    [parentView layoutSubviews];
    
    [reportView.textField becomeFirstResponder];
    
    return reportView;
}

- (void)dismissReportView {
    [self.viewBackShadow removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - IBActions

- (IBAction)actionPressReport:(id)sender {
    
    [self endEditing:YES];
    
    if (!self.textField.text.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter additionl info" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(proceedReportWithText:image:)]) {
        [self.delegate proceedReportWithText:self.textField.text image:self.imageReport];
    }
}

- (IBAction)actionPressCancel:(id)sender {
    [self resignFirstResponder];

    [self dismissReportView];

    if ([self.delegate respondsToSelector:@selector(cancelButtonPressed:)]) {
        [self.delegate cancelButtonPressed:self];
    }
}

- (IBAction)actionPressAddImg:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];

    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;

    UIViewController *vc = self.window.rootViewController;
    [vc presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UITextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return newLength <= DTAReportTextFieldMaxLength;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imageReport = image;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    
    self.constraintCenterY.constant = -50;

    [UIView animateWithDuration:0.3 animations:^ {
        [self layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    self.constraintCenterY.constant = 0;

    [UIView animateWithDuration:0.3 animations:^ {
        [self layoutIfNeeded];
    }];
}

#pragma mark - 

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.textField.delegate = self;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
    self.buttonReport.layer.cornerRadius = self.buttonReport.frame.size.height / 2;
    self.buttonReport.layer.borderColor = colorMahogany.CGColor;
    self.buttonReport.layer.borderWidth = 1;
    self.buttonReport.layer.masksToBounds = YES;

    self.buttonCancel.layer.cornerRadius = self.buttonCancel.frame.size.height / 2;
    self.buttonCancel.layer.borderColor = colorCreamCan.CGColor;
    self.buttonCancel.layer.borderWidth = 1;
    self.buttonCancel.layer.masksToBounds = YES;
}

- (void)tapAction {
    [self endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
