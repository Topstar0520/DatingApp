//
//  SubPackageCollectionCell.h
//  AudioBook
//
//  Created by Tushar  on 03/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubPackageCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *outerView;
@property (weak, nonatomic) IBOutlet UILabel *mnthLbl;
@property (weak, nonatomic) IBOutlet UILabel *rateLbl;
@property (weak, nonatomic) IBOutlet UILabel *perMnthLbl;
@property (weak, nonatomic) IBOutlet UILabel *bottomlbl;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

-(void)expandCell:(BOOL)isSelected;

@end
