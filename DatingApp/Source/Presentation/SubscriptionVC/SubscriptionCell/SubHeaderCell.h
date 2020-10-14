//
//  SubHeaderCell.h
//  AudioBook
//
//  Created by Tushar  on 02/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;

@property (weak, nonatomic) IBOutlet UILabel *headerLbl;
@property (weak, nonatomic) IBOutlet UILabel *unlimitedLbl;
@property (weak, nonatomic) IBOutlet UILabel *downloadLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstMonthLbl;

@end
