//
//  TextCell.h
//  AudioBook
//
//  Created by Tushar  on 19/11/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *subscriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//DEV
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end
