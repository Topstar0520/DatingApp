//
//  FacebookImageVC.m
//  DatingApp
//
//  Created by Apple on 13/02/20.
//  Copyright © 2020 Cleveroad Inc. All rights reserved.
//

#import "FacebookImageVC.h"
#import "imageCell.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"

//Collection View Values
#define NUMBER_OF_ITEMS_PER_ROW 3

#define COLLECTION_CELL_LEFT_PADDING 10.0f
#define COLLECTION_CELL_RIGHT_PADDING 10.0f
#define COLLECTION_CELL_INTER_ITEMS_PADDING 5.0f
#define COLLECTION_CELL_MIN_LINE_SPACING 5.0f

@interface FacebookImageVC ()
{
    NSMutableArray *imgArr;
    NSString *afterPageToken;
    NSString *nextPageToken;
}
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;

@end

@implementation FacebookImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Facebook Images";
    imgArr = [[NSMutableArray alloc]init];
    
    if (![FBSDKAccessToken currentAccessToken]) {
        if (!IS_HOST_REACHABLE) {
            [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
        }
        else {
            FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
            
//            [login logOut];
            
            [login logInWithPermissions:@[@"email", @"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                
                if (error) {
                    [self showAlertController:@"Facebook" andMessage:@"Facebook login error"];
                }
                else if (result.isCancelled) {
                    [self showAlertController:@"Facebook" andMessage:@"Facebook login canceled"];
                    
                }
                else {
                    // If you ask for multiple permissions at once, you
                    // should check if specific permissions missing
                    if ([result.grantedPermissions containsObject:@"user_photos"]) {
                        [self getFbImages];
                    }
                }
            }];
        }
    }else {
        [self getFbImages];
    }
}

-(void)getFbImages {
    
//    NSMutableDictionary *params  =  [[NSMutableDictionary alloc]initWithDictionary:@{@"fields": @"images{source}",@"limit":@"20"}];
    
    NSMutableDictionary *params  =  [[NSMutableDictionary alloc]initWithDictionary:@{@"fields": @"images{source}",@"limit":@"20"}];
    
    if (afterPageToken) {
        [params setObject:afterPageToken forKey:@"after"];
    }
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/photos/uploaded"
//                                  initWithGraphPath:@"/493902791237574/photos/uploaded"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        // Handle the result
        NSDictionary *responseDict = result;
        
        afterPageToken = [[[responseDict objectForKey:@"paging"] objectForKey:@"cursors"] objectForKey:@"after"];
        nextPageToken = [[responseDict objectForKey:@"paging"] objectForKey:@"next"];
        
            if (afterPageToken) {
                [imgArr addObjectsFromArray:[responseDict objectForKey:@"data"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                [self.imageCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:imgArr.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
                });
                
                [self.imageCollectionView reloadData];
            }else  {
                afterPageToken = @"";
                return ;
            }
        }];
}


- (IBAction)buttonLoadMoreAction:(id)sender {
    
    if (nextPageToken) {
        [self getFbImages];
    }else
        [self showAlertController:@"Facebook" andMessage:@"No more images available"];
    
}

- (void) showAlertController: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![message isEqualToString:@"No more images available"])
            [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UICollectionView Delegates

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"count arr%lu", (unsigned long)imgArr.count);
    return imgArr.count > 0 ? imgArr.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    imageCell *cell = (imageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"imageCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (imgArr.count > 0) {
        NSDictionary *dictImageData =[imgArr objectAtIndex:indexPath.row];
        NSArray *imageArray = [dictImageData objectForKey:@"images"];
        NSDictionary *newDict = [imageArray lastObject];
//        [cell.imageFB sd_setImageWithURL:[NSURL URLWithString:[newDict objectForKey:@"source"]] placeholderImage:nil];
        [cell.imageFB sd_setImageWithURL:[NSURL URLWithString:[newDict objectForKey:@"source"]] placeholderImage:[UIImage imageNamed:@"drefaultImage"] options:SDWebImageDelayPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){}];
    }
        
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dictImageData =[imgArr objectAtIndex:indexPath.row];
    NSArray *imageArray = [dictImageData objectForKey:@"images"];
    NSDictionary *newDict = [imageArray lastObject];
    self.imgUrlSring = [newDict objectForKey:@"source"];
    [self performSegueWithIdentifier:@"unwindFromFbImageToEdit" sender:nil];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgWidth = (SCREEN_WIDTH - (COLLECTION_CELL_INTER_ITEMS_PADDING *(NUMBER_OF_ITEMS_PER_ROW - 1)) - (2 * COLLECTION_CELL_LEFT_PADDING)) / NUMBER_OF_ITEMS_PER_ROW;
    return CGSizeMake(imgWidth, imgWidth);
}

#pragma mark collection view cell paddings
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_CELL_MIN_LINE_SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_CELL_INTER_ITEMS_PADDING;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10,10, 10); // top, left, bottom, right
}


@end
