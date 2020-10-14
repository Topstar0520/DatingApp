//
//  PackageCell.m
//  AudioBook
//
//  Created by Tushar  on 02/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "PackageCell.h"
#import "SubPackageCollectionCell.h"
//#import "UIColor+ColorCategory.h"
#import "SubscriptionPlans.h"

@implementation PackageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.choosepckLbl.text = @"Choose your Package";
    self.packageCollectionView.delegate = self;
    self.packageCollectionView.dataSource = self;
    [self.packageCollectionView registerNib:[UINib nibWithNibName:@"SubPackageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"SubPackageCollectionCell"];
    self.startLbl.text = @"START";
    
//    if ([[LanguageManager currentLanguageCode] isEqualToString:@"ar"]){
//        self.startLbl.font = [UIFont fontWithName:@"NeuzeitGro-Bol" size:15];
//    }else {
//        self.startLbl.font = [UIFont fontWithName:@"NeuzeitGro-Bol" size:18];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - UICollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.planArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SubscriptionPlans *planObj = [self.planArray objectAtIndex:indexPath.row];
    SubPackageCollectionCell *cell = (SubPackageCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SubPackageCollectionCell" forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SubPackageCollectionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    //fill details
    NSString *currency = @"$";
    NSString *rate;
    NSString *month;
    NSString *perMonth;
    

    rate = [currency stringByAppendingString: [NSString stringWithFormat:@"%.02f",planObj.originalPrice.floatValue]];
    // month = [NSString stringWithFormat:@"%@ %@",planObj.packageDuration.stringValue, planObj.packType];
//    NSString *packTypeStr = [NSString stringWithFormat:@"%@",planObj.description];
//    perMonth = [NSString stringWithFormat:@"($%.02f %@)",planObj.packagePerPrice.floatValue,packTypeStr];
    
    perMonth = [NSString stringWithFormat:@"%@",planObj.packagePerPrice];
 
        month = [NSString stringWithFormat:@"%@",planObj.planName];
    
    cell.rateLbl.text = rate;
    cell.mnthLbl.text = month;
    cell.perMnthLbl.text = perMonth;
    
    cell.bottomlbl.text = [NSString stringWithFormat:@"unlimited %@", planObj.planName];
    
//    NSString *limitedText = [planObj.limitedText  objectForKey:langPrefixStr];
//    if (limitedText.length > 0) {
//        cell.bottomlbl.text = limitedText;
//    }else {
//        cell.bottomlbl.text = @"";
//    }
    
    //set outer color
    UIColor *selColor;
    int index = (int)indexPath.row + 1;
    if (index % 3 == 1) {
        selColor = [self firstPackageColor];
    } else if (index % 3 == 2) {
        selColor = [self secondPackageColor];
    } else {
        selColor = [self thirdPackageColor];
    }
    
    cell.mnthLbl.textColor = selColor;
    cell.rateLbl.textColor = selColor;
    
    if (planObj.isPLanSelected) {
        [cell expandCell:YES];
        cell.outerView.layer.borderWidth = 0.8f;
        cell.outerView.layer.borderColor = selColor.CGColor;
    } else {
        cell.outerView.layer.borderWidth = 0.0f;
        [cell expandCell:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    SubscriptionPlans *planObj = [self.planArray objectAtIndex:indexPath.row];
    
    for (SubscriptionPlans *sObj in self.planArray) {
        sObj.isPLanSelected = NO;
    }
    
    if (planObj.isPLanSelected == NO) {
        planObj.isPLanSelected = YES;
    }
    
    [self.packageCollectionView reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self calculateRowWidth:120.0f],[self calculateRowHeight:169.5f]);
}
-(CGFloat) calculateRowHeight:(CGFloat) height{
    CGFloat fHeight;
    
    fHeight = (height/667)*SCREEN_HEIGHT;
    return fHeight;
}

-(CGFloat) calculateRowWidth:(CGFloat) width{
    CGFloat fWidth;
    fWidth = (width/375) * SCREEN_WIDTH;
    return fWidth;
}
#pragma mark collection view cell paddings
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0,0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIColor *) firstPackageColor {
    UIColor *redColor = [UIColor colorWithRed:243.0f/255.0f green:69.0f/255.0f  blue:88/255.0f alpha:1.0f];
    return redColor;
}

- (UIColor *) secondPackageColor {
    UIColor *yellow = [UIColor colorWithRed:248.0f/255.0f green:181.0f/255.0f  blue:41.0f/255.0f alpha:1.0f];
    return yellow;
}

- (UIColor *) thirdPackageColor {
    UIColor *blue = [UIColor colorWithRed:42.0f/255.0f green:231.0f/255.0f  blue:228.0f/255.0f alpha:1.0f];
    return blue;
}
@end
