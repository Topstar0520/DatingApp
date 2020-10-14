//
//  DTAPrivacyPolicyViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 12/4/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAPrivacyPolicyViewController.h"
#import <WebKit/WebKit.h>

@interface DTAPrivacyPolicyViewController ()

//@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation DTAPrivacyPolicyViewController

#pragma mark - LifeCycle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackButton];
    [self setupNavBarWithTitle:@"Privacy Policy"];
    
    NSString *privacyString = [NSString stringWithFormat:@"%@%@", DTAAPIServerHostname, DTAAPIPrivacyEndpoint];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:privacyString]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

@end
