//
//  SubscriptionVC.m
//  AudioBook
//
//  Created by Tushar  on 28/09/18.
//  Copyright © 2018 KanhaiyaKIPL. All rights reserved.
//

#import "SubscriptionVC.h"
#import "SubscriptionPlans.h"
#import "RageIAPHelper.h"
#import "SubHeaderCell.h"
#import "PackageCell.h"
#import "TextCell.h"
#import "DTASocket.h"
#import "DTASearchOptionsManager.h"
#import "DTAEditProfileViewController.h"
#import "DTATermsConditionsViewController.h"


#define SubscriptionProductId @"com.alrawi.1month"

@interface SubscriptionVC () {
    SubscriptionPlans *planObj;
    NSMutableArray *subPlanArr;
    NSString *productIdentifier;
    NSArray *productArr;
    NSNumber *isTrial;
    
}

@property (assign, atomic, getter=isNetworkRequestProcessing) BOOL networkRequestProcessing;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *subscriptionTableView;

@property (weak, nonatomic) IBOutlet UILabel *startLbl;
@property (weak, nonatomic) IBOutlet UIButton *termsBtn;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;


- (IBAction)buyProduct:(id)sender;
- (IBAction)crossTapped:(id)sender;
- (IBAction)moreBtnTapped:(id)sender;
- (IBAction)termsTapped:(id)sender;

@end

@implementation SubscriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    planObj = [SubscriptionPlans new];
    subPlanArr = [NSMutableArray new];
    
    //register for notification
    [self addNotification];
    
    //adjust footerview height
    [self adjustFooterVewHeight];
    
    //set fonts
    [self setAllFont];
    
    //set automatic dimesion for subsciption text cell
    self.subscriptionTableView.estimatedRowHeight = 50.0f;
    self.subscriptionTableView.rowHeight = UITableViewAutomaticDimension;
    
    //get subscriptions plans
    [self serviceCallForSubscriptionPlans];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    APPDELEGATE.delegate = self;
    [[self navigationController] setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBActions Methods

- (IBAction)buyProduct:(id)sender {
    //set product identifier
    SubscriptionPlans *subObj = [self getProductBundleId];
    if (subObj != nil) {
            productIdentifier = subObj.subBundleId;
        
         APP_DELEGATE.inAppIdentifireArr = [[NSArray alloc]initWithObjects:productIdentifier, nil];

            //product request
            [self loadProductDetails];
    } else {
        [self showAlertWithTitle:@"JollofDate" withMessage:@"Please select a subscription plan first"];
    }
}

- (IBAction)crossTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)moreBtnTapped:(id)sender {
//    PaymentOptionVC *povc = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentOptionVC"];
//    [self.navigationController pushViewController:povc animated:YES];
}

- (IBAction)termsTapped:(id)sender {
//    [self performSegueWithIdentifier:toTermsConditionsVC sender:self];
    UIStoryboard *mainStroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DTATermsConditionsViewController *webvc= [mainStroyboard instantiateViewControllerWithIdentifier:@"DTATermsConditionsViewControllerID"];
    
//    webvc.weblink = [NSString stringWithFormat:@"%@/%@/terms-conditions",STATIC_BASE_URL,langPrefixStr];

//    NSLog(@"terms link ========= > %@",[NSString stringWithFormat:@"%@/%@/terms-conditions",STATIC_BASE_URL,langPrefixStr]);

//    webvc.title_web = NSLocalizedString(@"SIGNUP_TERMS_TEXT", @"");
    webvc.isFromSubscriptionVC = YES;
    
    UINavigationController *navContPresent = [[UINavigationController alloc]initWithRootViewController:webvc];
    navContPresent.navigationBar.translucent=NO;
    
    [self presentViewController:navContPresent animated:YES completion:nil];
}


#pragma mark - Storyboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender; {
//    if ([segue.identifier isEqualToString:pushEditProfileViewControllerSegue]) {
    
        ((DTAEditProfileViewController *)segue.destinationViewController).isFromRegisterVC = YES;
//    }
}

#pragma mark - Instance Methods

-(void)setAllFont {
    self.startLbl.text = @"Start Your Free Month Now";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString: @"Terms & Conditions"
                                                                             attributes:@{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}]];
    
    [self.termsBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
//    [self.moreBtn setTitle:NSLocalizedString(@"S_OPTIONS", @"") forState:UIControlStateNormal];
    
//    if ([[LanguageManager currentLanguageCode] isEqualToString:@"ar"]){
//        self.startLbl.font = [UIFont fontWithName:@"NeuzeitGro-Bol" size:15];
//    }else {
//       self.startLbl.font = [UIFont fontWithName:@"NeuzeitGro-Bol" size:18];
//    }
}

-(void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:@"CompleteBookPurchase" object:nil];
}

-(void)showAlertWithTitle:(NSString *)atitle withMessage:(NSString *)message {
    UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:atitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction =[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)adjustFooterVewHeight {
    CGFloat h = (140.5 / 375.0) * SCREEN_WIDTH;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    self.footerView.frame = frame;
}

-(SubscriptionPlans *)getProductBundleId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.isPLanSelected == YES"];
    NSArray *filterArr = [subPlanArr filteredArrayUsingPredicate:predicate];
    if (filterArr.count > 0) {
       SubscriptionPlans  *subObj = [filterArr firstObject];
        return subObj;
    }
    return  nil;
}

//-(NSString *)subscriptionTextArabic {
//    NSString *subText = NSLocalizedString(@"Subscription_Info", @"");
//    NSString *head1Str = NSLocalizedString(@"Subscription_Heading_1",@"");
//    NSString *detailStr1 = NSLocalizedString(@"Subscription_Detail_1",@"");
//    NSString *detailStr2 = NSLocalizedString(@"Subscription_Detail_2",@"");
//    NSString *detailStr3 = NSLocalizedString(@"Subscription_Detail_3",@"");
//    NSString *detailStr4 = NSLocalizedString(@"Subscription_Detail_4",@"");
//    NSString *detailStr5 = NSLocalizedString(@"Subscription_Detail_5",@"");
//    NSString *detailStr6 = NSLocalizedString(@"Subscription_Detail_6",@"");
//    NSString *detailStr7 = NSLocalizedString(@"Subscription_Detail_7",@"");
//    NSString *detailStr8 = NSLocalizedString(@"Subscription_Detail_8",@"");
//    NSString *detailStr9 = NSLocalizedString(@"Subscription_Detail_9",@"");
//    NSString *detailStr10 = NSLocalizedString(@"Subscription_Detail_10",@"");
//    NSString *finalText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@\n\n%@",subText,head1Str,detailStr1,detailStr2,detailStr3,detailStr4,detailStr5,detailStr6,detailStr7,detailStr8,detailStr9,detailStr10];
//    return finalText;
//}

#pragma mark - Music Bottom View Delegates

/**
 This method is use for show music bar in bottom.
 */
//-(void)isShowMusicBottom {
//    NSArray *subViewArray = [APPDELEGATE.window subviews];
//    for (id obj in subViewArray)
//    {
//        if ([obj isKindOfClass:[MusicBottomView class]]) {
//            [obj setHidden:YES];
//        }
//    }
//}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if(indexPath.row == 0) {
//        height = (303.0 / 375.0) * SCREEN_WIDTH;
        height = (250.0 / 375.0) * SCREEN_WIDTH;
    }else if (indexPath.row == 1) {
        height =  (300.0 / 375.0) * SCREEN_WIDTH;
    }else if (indexPath.row == 2){
        return UITableViewAutomaticDimension;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        //header cell
        SubHeaderCell *headerCell  = [tableView dequeueReusableCellWithIdentifier:@"SubHeaderCell"];
        if (headerCell == nil) {
            headerCell = [[[NSBundle mainBundle]loadNibNamed:@"SubHeaderCell" owner:self options:nil] lastObject];
        }
        headerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerCell.backgroundColor = [UIColor clearColor];
        cell = headerCell;
        
    } else if (indexPath.row == 1) {
        //package cell
        PackageCell *pckgCell  = [tableView dequeueReusableCellWithIdentifier:@"PackageCell"];
        if (pckgCell == nil) {
            pckgCell = [[[NSBundle mainBundle]loadNibNamed:@"PackageCell" owner:self options:nil] lastObject];
        }
        
        //automatic selected plan
        if (subPlanArr.count>0) {
            SubscriptionPlans *planObj = [subPlanArr objectAtIndex:1];
            if (planObj != nil) {
                planObj.isPLanSelected = YES;
            }
        }
    
        pckgCell.planArray =  subPlanArr;
        pckgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        pckgCell.backgroundColor = [UIColor clearColor];
        [pckgCell.subscriptionBtn addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
        cell = pckgCell;
    } else if (indexPath.row == 2){
        //header cell
       TextCell *textCell  = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        if (textCell == nil) {
            textCell = [[[NSBundle mainBundle]loadNibNamed:@"TextCell" owner:self options:nil] lastObject];
        }
        textCell.selectionStyle = UITableViewCellSelectionStyleNone;
        textCell.backgroundColor = [UIColor clearColor];
//        if ([[LanguageManager currentLanguageCode] isEqualToString:@"ar"]) {
//            textCell.subscriptionTextView.textAlignment = NSTextAlignmentRight;
//            textCell.subscriptionTextView.text = [self subscriptionTextArabic];
//        } else {
            textCell.subscriptionTextView.textAlignment = NSTextAlignmentLeft;
            textCell.subscriptionTextView.text = @"";
//        }
        [textCell.termsBtn addTarget:self action:@selector(termsTapped:) forControlEvents:UIControlEventTouchUpInside];
        [textCell.moreBtn addTarget:self action:@selector(moreBtnTapped:) forControlEvents:UIControlEventTouchUpInside];

        cell = textCell;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma mark - InAppPurchase

-(void)loadProductDetails {
//    if ([CommonFunctions reachabiltyCheck]) {
    if (IS_HOST_REACHABLE) {
        productArr=nil;
    
        [APP_DELEGATE.hud show];
        [[RageIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            if (success)
            {
                NSLog(@"product loaded successfully......");
                productArr = products;
                
                if (productArr.count > 0)
                    [self buyProduct];
                else
                    [APP_DELEGATE.hud dismiss];
            }
            else
            {
                [APP_DELEGATE.hud dismiss];
                [self showAlertWithTitle:@"JollofDate" withMessage:@"Loading product failed from iTunes. Please try again later."];
            }
        }];
    } else {
        [self showAlertController:NSLocalizedString(DTAInternetConnectionFailedTitle, nil) andMessage:NSLocalizedString(DTAInternetConnectionFailed, nil)];
    }
}

- (void) showAlertController: (NSString *) title andMessage: (NSString *) message {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:action];
    
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)buyProduct {
    SKProduct *productN;
    
    for (SKProduct *product in productArr)
    {
        if([product.productIdentifier isEqualToString:productIdentifier])
        {
            productN =  product;
            break;
        }
    }
    
    if (productN != nil)
        [[RageIAPHelper sharedInstance] buyProduct:productN];
    else
    {
        [APP_DELEGATE.hud dismiss];
        [self showAlertWithTitle:@"JollofDate" withMessage:@"Loading product failed from iTunes. Please try again later."];
    }
}

#pragma mark - Notification Method

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    NSLog(@"productPurchased %@",productIdentifier);
    
    //extract recipt from bundle
    NSURL *receiptURL = [[NSBundle mainBundle] performSelector:@selector(appStoreReceiptURL)];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptString = [receipt base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    
    if (productIdentifier)
    {   //upload recipt to server
        [self apiToBuyBookStatusPostOnServerWithreceipt:receiptString];
    }
}

-(void)adjustTableViewbottom:(NSNotification *)notify {
    if (notify.object) {
        NSString *bottomVAlue = [notify object];
        if ([bottomVAlue isEqualToString:@"0"]) {
            self.tableBottomContraint.constant = 0;
            self.moreBottom.constant = 0;
        }
        else {
            self.moreBottom.constant = 0;
            self.tableBottomContraint.constant = 35;
        }
    }
//    [CommonFunctions bottomSpace:notify withConstraints:self.tableBottomContraint];
}


#pragma mark - Webservice Methods

-(void)serviceCallForSubscriptionPlans {
    
    if (IS_HOST_REACHABLE) {
        [APP_DELEGATE.hud show];
       
        
        [DTAAPI fetchPlanListWithParameters:^(NSError *error, NSArray *dataArr) {
            
            [APP_DELEGATE.hud dismiss];
            
            if (!error) {
                
                if (dataArr.count > 0) {
                    subPlanArr = [planObj makeWithPlanArray:dataArr];
                    [self.subscriptionTableView setContentOffset:CGPointZero animated:YES];
                    [self.subscriptionTableView reloadData];
                }
            }
        }];
    } else {
        [self showAlertWithTitle:@"JollofDate" withMessage:@"No internet connection."];
    }
}

/**
 Api used to update server when subscription plan purchased
 */
-(void)apiToBuyBookStatusPostOnServerWithreceipt:(NSString *)receipt {
    
    if (IS_HOST_REACHABLE) {
        [APP_DELEGATE.hud show];
        
        SubscriptionPlans *subObj;
        subObj =  [self getProductBundleId];
        if (subObj != nil) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:@"ios" forKey:@"os"];
            [params setObject:subObj.subcId forKey:@"plan_id"];
//            [params setObject:@"" forKey:@"amount"];
            [params setObject:receipt forKey:@"transaction_key"];
//            [params setObject:@"" forKey:@"transaction_data_android"];
            
            [DTAAPI apiForPurchasePlan:params completion:^(NSError *error, NSArray *dataArr) {
                if (!error) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if (dataArr.count > 0) {
                        NSLog(@"purchase plan data %@", dataArr);
                        
                    }
                }
                
                else {
                    [self showAlertController:@"Error" andMessage:error.userInfo[@"message"]];
                }
                
                [APP_DELEGATE.hud dismiss];
                
             }];
            
            
//            [service purchaseApiRequestWithParameter:params withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//                [CommonFunctions removeActivityIndicator];
//                if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
//                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
//                    NSInteger statusCode = httpResponse.statusCode;
//                    if (statusCode == 200) {
//                        NSLog(@"Successfully updated reciept");
//                        //show message
//                        NSDictionary *responseDic = (NSDictionary *)responseObject;
//                        NSString *message =[responseDic objectForKey:@"reply"];
//                        UIAlertController *alertController  = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"APP_NAME", @"") message:message preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *okAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                              //post notification to refresh subscrption message
//                               [[NSNotificationCenter defaultCenter] postNotificationName:@"AfterSubscription" object:nil];
//                               [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//                        }];
//
//                        [alertController addAction:okAction];
//                        [self presentViewController:alertController animated:YES completion:nil];
//
//
//                    }
//                }
//            } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
//                [CommonFunctions removeActivityIndicator];
//                //            [CommonFunctions removeActivityIndicatorFromViewController:self];
//                DLog(@"%@",error);
//            }];
        }
    } else {
        [self showAlertWithTitle:NSLocalizedString(@"APP_NAME", @"") withMessage:NSLocalizedString(@"NONETWORKMSG", @"")];
    }
}

@end
