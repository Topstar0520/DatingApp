//
//  PackageCell.h
//  AudioBook
//
//  Created by Tushar  on 02/10/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *packageCollectionView;
@property (nonatomic,strong) NSMutableArray *planArray;

@property (weak, nonatomic) IBOutlet UILabel *choosepckLbl;
@property (weak, nonatomic) IBOutlet UIButton *subscriptionBtn;
@property (weak, nonatomic) IBOutlet UILabel *startLbl;

@end
