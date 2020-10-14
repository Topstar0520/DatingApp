//
//  DTAProfileSummaryTableViewCell.m
//  DatingApp


#import "DTAProfileSummaryTableViewCell.h"

@implementation DTAProfileSummaryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configureCellWithSummary:(NSString *)summary sender:(id)sender row:(NSInteger)row {
   
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 15.f;
    
    if(summary) {
        self.summaryTextView.attributedText = [[NSAttributedString alloc] initWithString:summary attributes:@{ NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:17.0] }];
    }
    else {
        self.summaryTextView.attributedText = [[NSAttributedString alloc] initWithString:@""];
    }
    
    self.summaryTextView.delegate = sender;
    self.summaryTextView.tag = row;
    //DEV
    [self.numberOfSymbolsLbl setHidden:true];
//    [self changeNumberOfSymbols:self.summaryTextView.text.length ? self.summaryTextView.text.length : 0];
}

- (void)changeNumberOfSymbols:(NSInteger )numberOfSymbols {
    self.numberOfSymbolsLbl.text = [NSString stringWithFormat:@"%li/%i", (long)numberOfSymbols, kMaxNumberOfSummarySymbols];
}

@end
