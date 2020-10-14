//
//  InstagramViewController.m
//  DatingApp
//
//  Created by Apple on 30/04/19.
//  Copyright © 2019 Cleveroad Inc. All rights reserved.
//

#import "InstagramViewController.h"
#import <WebKit/WebKit.h>

@interface InstagramViewController ()<WKNavigationDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UILabel *navigationTitle;

@property UIProgressView *progressView;

@end

@implementation InstagramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setUpProgressView];
    self.webView = [self setUpWebView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.authString]]];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setUpProgressView {
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    
    self.progressView.progress = 0.0;
    
    self.progressView.tintColor = [UIColor colorWithRed:0.88 green:0.19 blue:0.42 alpha:1.0];
    
    self.progressView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.navigationView addSubview:self.progressView];
    
    [[_navigationView.bottomAnchor constraintEqualToAnchor:self.progressView.bottomAnchor constant:1] setActive:YES];
    
    [[_navigationView.leadingAnchor constraintEqualToAnchor:self.progressView.leadingAnchor constant:1] setActive:YES];
    
    [[_navigationView.trailingAnchor constraintEqualToAnchor:self.progressView.trailingAnchor] setActive:YES];
}

- (WKWebView *) setUpWebView {
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.websiteDataStore = WKWebsiteDataStore.nonPersistentDataStore;
    
    WKWebView *webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64) configuration:config];
    
    webview.navigationDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];

    [self.view addSubview:webview];
    
    return webview;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    _progressView.alpha = 1.0;
    [_progressView setProgress:self.webView.estimatedProgress animated:YES];
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        //float progress = _webView.estimatedProgress;
        
        if (self.webView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.progressView.alpha = 0;
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationTitle.text = webView.title;
    self.progressView.progress = 0.0;
    self.progressView.alpha = 0.0;
}

//Phone - raajkumar929
//Password - 8233856749

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *urlString = navigationAction.request.URL.absoluteString;
    NSLog(@"urlString = %@", urlString);

    if ([urlString hasPrefix:@"https://www.konstantinfo.com/"]) {

        NSLog(@"getting");
        NSRange range = [urlString rangeOfString:@"#access_token="];

        NSString *successStr = [urlString substringWithRange:NSMakeRange(range.location+range.length, urlString.length-(range.location+range.length))];
        NSLog(@"successStr = %@", successStr);

        [_delegate getInstagramLoginToken:successStr];

        decisionHandler(WKNavigationActionPolicyCancel);

        [self dismissViewControllerAnimated:YES completion:nil];

        return;
    }
    else {
        NSLog(@"not getting");
    }
    
//    NSString *urlString = navigationAction.request.URL.absoluteString;
//    NSLog(@"urlString = %@", urlString);
//
//    NSURL *Url = navigationAction.request.URL;
//    NSArray *UrlParts = [Url pathComponents];
//
//    if ([UrlParts count] == 0) {
//
//        NSLog(@"[UrlParts count] == 0");
//
//        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
//
//        if (tokenParam.location != NSNotFound) {
//
//            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
//            // If there are more args, don't include them in the token:
//            NSRange endRange = [token rangeOfString: @"&"];
//
//            if (endRange.location != NSNotFound) {
//                token = [token substringToIndex: endRange.location];
//            }
//
//            if ([token length] > 0 ) {
//                // call the method to fetch the user's Instagram info using access token
//                NSLog(@"call the method to fetch the user's Instagram info using access token");
//
//                [_delegate getInstagramLoginToken:token];
//
//                decisionHandler(WKNavigationActionPolicyCancel);
//
//                [self dismissViewControllerAnimated:YES completion:nil];
//
//                return;
//            }
//        }
//        else {
//
//        }
//    }
//    else {
//
//        NSLog(@"[UrlParts count] != 0");
//
//        NSRange tokenParam = [urlString rangeOfString: @"access_token="];
//
//        if (tokenParam.location != NSNotFound) {
//
//            NSString* token = [urlString substringFromIndex: NSMaxRange(tokenParam)];
//            // If there are more args, don't include them in the token:
//            NSRange endRange = [token rangeOfString: @"&"];
//
//            if (endRange.location != NSNotFound) {
//                token = [token substringToIndex: endRange.location];
//            }
//
//            if ([token length] > 0 ) {
//                // call the method to fetch the user's Instagram info using access token
//                NSLog(@"call the method to fetch the user's Instagram info using access token");
//
//                [_delegate getInstagramLoginToken:token];
//
//                decisionHandler(WKNavigationActionPolicyCancel);
//
//                [self dismissViewControllerAnimated:YES completion:nil];
//
//                return;
//            }
//        }
//        else {
//            NSLog(@"[UrlParts count] != 0");
//        }
//    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = navigationResponse.response;
        if (response.statusCode == 200) {
            decisionHandler(WKNavigationResponsePolicyAllow);
            return;
        }
        else {
            decisionHandler(WKNavigationResponsePolicyCancel);
            return;
        }
    }
    else {
        
        [_delegate getInstagramLoginToken:@""];
        
        decisionHandler(WKNavigationResponsePolicyAllow);
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return;
    }
}

@end
