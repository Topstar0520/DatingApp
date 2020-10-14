//
//  DTAProfileSummaryTableViewCell.h
//  DatingApp


#import <UIKit/UIKit.h>
#import "SZTextView.h"

static const int kMaxNumberOfSummarySymbols = 80;

static NSString * const kDTAProfileSummaryTableViewCell = @"profileSummaryTableViewCell";

@interface DTAProfileSummaryTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet SZTextView *summaryTextView;
@property (nonatomic, weak) IBOutlet UILabel *numberOfSymbolsLbl;
@property (strong, nonatomic) IBOutlet UILabel *labelQuestion;
- (void)configureCellWithSummary:(NSString *)summary sender:(id)sender row:(NSInteger )row;
- (void)changeNumberOfSymbols:(NSInteger )numberOfSymbols;

@end
