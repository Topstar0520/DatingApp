//
//  DTATermsConditionsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/14/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#import "DTATermsConditionsViewController.h"
#import <WebKit/WebKit.h>

@interface DTATermsConditionsViewController ()

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation DTATermsConditionsViewController

#pragma mark - LifeCycle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    [self setupNavBarWithTitle:@"Terms & Conditions"];
    
    //DEV
    if (_isFromSubscriptionVC) {
    [self addBackButtonInNavigationItem:self.navigationItem forNavigationController:self.navigationController withTarget:self andSelector:@selector(backBarBtnPressed)];
        self.navigationItem.title = @"Terms & Conditions";
        NSString *privacyString = [NSString stringWithFormat:@"%@%@", DTAAPIServerHostname, DTAAPITermsIAPEndpoint];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacyString]]];
    } else {
        NSString *privacyString = [NSString stringWithFormat:@"%@%@", DTAAPIServerHostname, DTAAPITermsEndpoint];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacyString]]];
    }
    
    
    
}
#pragma mark - Instance Methods
/**
 Method for dismiss viewcontroller
 */
-(void)backBarBtnPressed
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)addBackButtonInNavigationItem:(UINavigationItem*) navigationItem
forNavigationController:(UINavigationController*) navigationController
withTarget:(id) target
                         andSelector:(SEL) selector {
    //    UIImage *backImage = [UIImage imageNamed:@"back_arrow"];
    
    UIImage *backImage = [UIImage imageNamed:@"bt_back_w"];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f,50, 44)];
    
    
    [backButton setImage:backImage forState:UIControlStateNormal];
    if (target != nil && selector != nil) {
        [backButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    } else {
        
        [backButton addTarget:navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    }
//     backButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem *barButtonBack = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -20.f;
    
    [navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,barButtonBack,nil]];
    
}

@end
