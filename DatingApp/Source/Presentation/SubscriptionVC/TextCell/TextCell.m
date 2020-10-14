//
//  TextCell.m
//  AudioBook
//
//  Created by Tushar  on 19/11/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subscriptionTextView.userInteractionEnabled = NO;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString: @"Terms & Conditions"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
    
    [self.termsBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
//    [self.moreBtn setTitle:NSLocalizedString(@"S_OPTIONS", @"") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
