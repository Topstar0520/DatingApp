//
//  DTAEmailUsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 10/28/15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTAEmailUsViewController.h"
#import <MessageUI/MessageUI.h>

@interface DTAEmailUsViewController () <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelEmailUs;

- (IBAction)tapOnLabelEmailUs:(id)sender;

@end

@implementation DTAEmailUsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBarWithTitle:@"Email Us"];
}

#pragma mark - IBAction

- (IBAction)tapOnLabelEmailUs:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    
        [composeViewController setMailComposeDelegate:self];
//        [composeViewController setToRecipients:@[@"info@tolu.com"]];//DEV 26 may 2020
        [composeViewController setToRecipients:@[@"team@jollofdate.com"]];
        
        [composeViewController setSubject:@"Suggestion"];
        
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
}

#pragma mark - EmailComposerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
