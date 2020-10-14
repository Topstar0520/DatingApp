//
//  DTAChatViewController.m
//  DatingApp
//
//  Created by Maksim on 09.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#define TABBAR_HEIGHT 49.0
#define TEXTFIELD_HEIGHT 70.0

NSString * const kChatSendMessageId = @"chatId";
NSString * const kChatSendMessageText = @"message";

typedef NS_ENUM(NSUInteger, DTAChatMessageEnum) {
    DTAChatMessageEnumBg = 1,
    DTAChatMessageEnumMessage,
    DTAChatMessageEnumDate
};

#import "DTAChatViewController.h"
#import "UserDetailedInfoViewController.h"
#import "DTASocket.h"
#import "DTAMessage.h"
#import "User+Extension.h"
#import "MBProgressHUD.h"
#import "NSDate+ChatTimeFormat.h"


static NSString * const myCellIdentifier = @"DTAChatMyCell";
static NSString * const frienfCellIdentifier = @"DTAChatFriendCell";
static NSString * const dateCellIdentifierDate = @"DTAChatDateCell";

@interface DTAChatViewController () <UITextFieldDelegate, DTASocketIOServiceDelegate>
{
    NSTimer *typeTimer;
}
@property(nonatomic, strong) IBOutlet UITextField *tfEntry;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DTASocket *socket;
@property (nonatomic, strong) User *companionUser;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL firstRun;
@property (nonatomic, assign) BOOL showKyboard;
@property (nonatomic, assign) BOOL connectToSoket;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *height;
@property (nonatomic, assign) CGFloat heightK;
@property (nonatomic, assign) CGFloat addHeght;
@property (nonatomic, assign) BOOL insetrCell;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tbleViewBottomConstraint;


@end

@implementation DTAChatViewController

#pragma mark - LifeCycle

- (void)dealloc {
    [self.socket sendEvent:kLSSocketTyping withPayload:@[@{kChatSendMessageId:self.chatId, @"fromUserID": self.userId,@"toUserID": self.friendId,@"status":@false}]];
    [self.socket removeDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tfEntry.delegate = self;
//    self.tfEntry.clearButtonMode = UITextFieldViewModeWhileEditing;
    
//    [self registerForKeyboardNotifications];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 50)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setNumberOfLines:2];
    titleLabel.text = self.titleString;
    
    self.navigationItem.titleView = titleLabel;
   
    self.socket = [DTASocket sharedInstance];
    
    [self.socket addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bt_nb_info"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(actionPressRightBarButton:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //--- fetch companion profile if not deleted
    if (self.isFriendDeleted) {
        self.buttonSend.enabled = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else {
        self.companionUser = [User MR_findFirstByAttribute:@"userId" withValue:self.friendId];
    
        if (!self.companionUser) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        
        __weak typeof(self) weakSelf = self;
        
        [DTAAPI profileFullFetchForUserId:self.friendId completion:^(NSError *error, NSArray *dataArr) {
            if (error) {
                NSLog(@"Fail profileFetchForUser request");
            }
            else {
                weakSelf.companionUser = [User MR_findFirstByAttribute:@"userId" withValue:weakSelf.friendId];
                self.detailedUser = [[User alloc] initWithDictionary:dataArr[0]];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    self.dataArr = [NSMutableArray new];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 77.0;
    
    self.firstRun = true;
    
    self.userId = [[User currentUser] userId];
    
    [self setupBackButton];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    if(self.socket.connectToSoket) {
        self.connectToSoket = YES;
        [self.socket sendEvent:kLSSocketEventOpen withPayload:@[@{@"user":self.friendId}]];
    }
    else {
        self.connectToSoket = NO;
        [self.socket connect];
    }
}

- (void)appDidEnterBackground {
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    textView.enablesReturnKeyAutomatically = YES;
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    
    [self freeKeyboardNotifications];
}
// Implement loadView to create a view hierarchy programmatically, without using a nib.

- (void)loadView {
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    containerView = [[UIView alloc] init];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height >= 812) {
        containerView.frame = CGRectMake(0, self.view.frame.size.height - 94, self.view.frame.size.width, 80);
        [textView resignFirstResponder];
    }else{
        containerView.frame = CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 80);
        [textView resignFirstResponder];
    }
    
    containerView.layer.borderWidth=1.0;
    containerView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(15, 10, containerView.frame.size.width-90, 50)];
    textView.isScrollable = NO;
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    textView.minNumberOfLines = 1;
    textView.maxNumberOfLines = 3;
    // you can also set the maximum height in points with maxHeight
    // textView.maxHeight = 200.0f;
    textView.minHeight = 50.0f;
    textView.font = [UIFont fontWithName:@"Helvetica" size:18];
    textView.returnKeyType = UIReturnKeyDefault; //just as an example
//    textView.font = [UIFont fontWithName:@"Helvetica-Regular" size:14];
    textView.textColor = [UIColor blackColor];
    textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor colorWithRed:241.f/255.f green:241.f/255.f blue:241.f/255.f alpha:1.0];
    textView.placeholder = @"Please enter message";
    
    // textView.text = @"test\n\ntest";
    // textView.animateHeightChange = NO; //turns off animation
    containerView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:containerView];
    
//    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
//    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
//    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
//    entryImageView.frame = CGRectMake(5, 0, 248, 40);
//    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//
//    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
//    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
//    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
//    [containerView addSubview:imageView];
    [containerView addSubview:textView];
//    [containerView addSubview:entryImageView];
    
//    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
//    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
    doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBtn.frame = CGRectMake(containerView.frame.size.width - 62, 10, 52, 36);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
//    [doneBtn setImage:[UIImage imageNamed:@"comment_send"] forState:UIControlStateNormal];
    [doneBtn setTitle:@"Send" forState:UIControlStateNormal];
    doneBtn.enabled=NO;
    
//    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
//    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    [doneBtn setTitleColor:[UIColor colorWithRed:254.f/255.f green:205.f/255.f blue:96.f/255.f alpha:1.0] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
//    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
    [containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,containerView.frame.origin.y) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor=[UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView=[UIView new];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    |UIViewAutoresizingFlexibleHeight;
    [self.tableView registerNib:[UINib nibWithNibName:@"DTAChatMyCell" bundle:nil] forCellReuseIdentifier:myCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DTAChatFriendCell" bundle:nil] forCellReuseIdentifier:frienfCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DTAChatDateCell" bundle:nil] forCellReuseIdentifier:dateCellIdentifierDate];
    
    [self.view addSubview:self.tableView];
    
//    self.lbl_NoComments = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 25)];
//    self.lbl_NoComments.backgroundColor = [UIColor clearColor];
//    self.lbl_NoComments.textColor = UIColorFromRedGreenBlue(88, 88, 88);
//    self.lbl_NoComments.font = [UIFont fontWithName:@"Gentona-Book" size:15.0];
//    self.lbl_NoComments.textAlignment = NSTextAlignmentCenter;
//    self.lbl_NoComments.text  = @"No Comments Avaialble";
//    [self.view addSubview:self.lbl_NoComments];
//    self.lbl_NoComments.hidden = YES;
}

#pragma mark - IBActions

- (IBAction)pressBackButton:(id)sender {
    [self.socket removeDelegate:self];
    
}

- (IBAction)actionPressRightBarButton:(id)sender {
    [self performSegueWithIdentifier:toDetailedUserInfoSegue sender:self];
}

#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.height >= 812)
//        containerView.frame = CGRectMake(0, self.view.frame.size.height - 74, self.view.frame.size.width, 74);
        containerView.frame = CGRectMake(0, self.view.frame.size.height - 94, self.view.frame.size.width, 80);
    else
        containerView.frame = CGRectMake(0, self.view.frame.size.height - 70, self.view.frame.size.width, 80);
//        containerView.frame = CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56);
        
    
    [textView resignFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(![self.dataArr[indexPath.row] isKindOfClass:[NSString class]]) {
        DTAMessage *ms = self.dataArr[indexPath.row];
        
        if([self.userId isEqualToString:ms.from]) {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DTAChatMyCell"];
            
            UIView *bg = [cell viewWithTag:DTAChatMessageEnumBg];
            [bg.layer setCornerRadius:19.0];
            bg.backgroundColor = colorCreamCan;
            
            UILabel* message =(UILabel *) [cell viewWithTag:DTAChatMessageEnumMessage];
            message.text = ms.message;
            
            UILabel *date = (UILabel *)[cell viewWithTag:DTAChatMessageEnumDate];
            date.text = [self timeStringAgoSinceDate:ms];
            
            if(self.insetrCell) {
                self.addHeght += cell.frame.size.height;
                self.insetrCell = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DTAChatFriendCell"];
        
            UIView *bg = [cell viewWithTag:DTAChatMessageEnumBg];
            [bg.layer setCornerRadius:19.0];
            
            UILabel* message =(UILabel *) [cell viewWithTag:DTAChatMessageEnumMessage];
            message.text = ms.message;
            
            UILabel *date = (UILabel *)[cell viewWithTag:DTAChatMessageEnumDate];
            date.text = [self timeStringAgoSinceDate:ms];
            
            if(self.insetrCell) {
                self.addHeght += cell.frame.size.height;
                self.insetrCell = NO;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DTAChatDateCell"];
    
        UILabel* dateLable = (UILabel *)[cell viewWithTag:1];
        dateLable.text = self.dataArr[indexPath.row];
                
        return cell;
    }
}

#pragma mark -

- (void)refresh:(UIRefreshControl *)refreshControl {
    
    if (self.dataArr.count > 0) {
        DTAMessage *message = nil;
        
        if([self.dataArr[0] isKindOfClass:[DTAMessage class]]) {
            message = self.dataArr[0];
        }
        else {
            message = self.dataArr[1];
        }
        
        if (message.messageId) {
            [self.socket sendEvent:kLSSocketEventHistory withPayload:@[@{@"lastMessageId":message.messageId, @"chatId":self.chatId}]];
            [refreshControl endRefreshing];
        }
        else {
            [refreshControl endRefreshing];
        }
    }
    else {
        [refreshControl endRefreshing];
    }
}

- (void)scrollToBottom {
    if(self.dataArr.count > 1) {
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:(self.dataArr.count - 1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionBottom animated:!self.firstRun];
    }
}


- (void)convertHistoryToArray:(NSArray *)array {
    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        [self.dataArr addObject:[[DTAMessage alloc] initWithDictionary:dict]];
    }
    
    [self.tableView reloadData];
}

- (void)addHistory:(NSArray *)array {
    NSMutableArray *tempArr = [NSMutableArray new];

    for (NSInteger i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        [tempArr addObject:[[DTAMessage alloc] initWithDictionary:dict]];
    }
    
    for (NSInteger i = 0; i < tempArr.count; i++) {
        DTAMessage *ms = tempArr[i];
        [self.dataArr insertObject:ms atIndex:i];
    }
}

- (NSString *)convertMessageTime:(double )time {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    return [dateFormatter stringFromDate:date];
}

- (BOOL)compareDate:(DTAMessage *)firstMessage nextMessage:(DTAMessage *)nextMessage {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:firstMessage.time];
    
    NSDate *nextDate = [NSDate dateWithTimeIntervalSince1970:nextMessage.time];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components1 = [gregorianCalendar components:NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *components2 = [gregorianCalendar components:NSCalendarUnitDay fromDate:nextDate];
    
    if (components1.day - components2.day !=  0) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSString *)timeStringAgoSinceDate:(DTAMessage *)message {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:message.time];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *now = [NSDate date];
    
    NSDate *earliest = [now earlierDate:date];
    
    NSDate *latest = (earliest == now) ? date : now;
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitSecond) fromDate:earliest toDate:latest options:NSCalendarMatchStrictly];
    
    
    if (components.year >= 2) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    }
    else if (components.year >= 1) {
        return @"Last year";
    }
    else if (components.month >= 2) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    }
    else if (components.month >= 1) {
        return @"Last month";
    }
    else if (components.weekOfYear >= 2) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    }
    else if (components.weekOfYear >= 1) {
        return @"Last week";
    }
    else if (components.day >= 2) {
        return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
    }
    else if (components.day >= 1) {
        return @"Yesterday";
    }
    else if (components.hour >= 2) {
        return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
    }
    else if (components.hour >= 1) {
        return @"An hour ago";
    }
    else if (components.minute >= 2) {
        return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
    }
    else if (components.minute >= 1) {
        return @"A minute ago";
    }
    else if (components.second >= 3) {
        return [NSString stringWithFormat:@"%ld seconds ago", (long)components.second];
    }
    else {
        return @"Just now";
    }
}

-(void)sendBtnAction :(id) sender {
//- (void)sendMessage {
    
    if(textView.text.length > 0) {
        doneBtn.enabled=YES;
        NSString *message = textView.text;
        message = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if (message.length > 0) {
            textView.text = @"";
            [self.socket sendEvent:kLSSocketEventMessage withPayload:@[@{kChatSendMessageId:self.chatId, kChatSendMessageText:message}]];
            [self.socket sendEvent:kLSSocketTyping withPayload:@[@{kChatSendMessageId:self.chatId, @"fromUserID": self.userId,@"toUserID": self.friendId,@"status":@false}]];
        }
    }else
        doneBtn.enabled=NO;
}

- (void)getMessage:(DTAMessage *)message {
    BOOL insertDate = NO;

    if(self.dataArr.count > 1 && [self compareDate:self.dataArr.lastObject nextMessage:message]) {
        insertDate = YES;
    }
    
    [self.dataArr addObject:message];
    
    NSMutableArray *indexReload = [NSMutableArray new];
    
    NSIndexPath *indehP = [NSIndexPath indexPathForRow:(self.dataArr.count - 1) inSection:0];
    
    if(insertDate) {
//        NSIndexPath *indehPDat = [NSIndexPath indexPathForRow:(self.dataArr.count - 2) inSection:0];
//        [indexReload addObject:indehPDat];
    }
    
    [indexReload addObject:indehP];
    
//    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexPaths:indexReload withRowAnimation:UITableViewRowAnimationLeft];
    
//    [self.tableView endUpdates];
    
    [self scrollToBottom];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:toDetailedUserInfoSegue]) {
        UserDetailedInfoViewController *destVC = segue.destinationViewController;
//        destVC .detailedUser = self.companionUser;
        destVC.detailedUser = self.detailedUser;
        destVC.hideButtons = DTAButtonsHideStateLike + DTAButtonsHideStateDislike + DTAButtonsHideStateChat;
    }
}

#pragma mark - DTASocketIOServiceDelegate

- (void)socketService:(DTASocket *)service didReceiveEvent:(NSString *)event withPayload:(NSArray *)payload
{

    NSString *titleString = [NSString stringWithFormat:@"%@\n%@", self.titleString, @"typing"];
    UILabel *lTitle = (UILabel *)self.navigationItem.titleView;
    
    if ([event isEqualToString:kLSSocketTyping]) {
//        NSLog(@"%@", payload);

        if ([[[payload objectAtIndex:0] valueForKey:@"status"]boolValue] == true) {
//
//            if ([[[payload objectAtIndex:0] valueForKey:@"fromUserID"] isEqualToString:self.userId]) {
//                lTitle.text = self.titleString;
//            }
//            else {
                lTitle.text = titleString;
                lTitle.numberOfLines = 2;
//              typeTimer =  [NSTimer scheduledTimerWithTimeInterval:3.0 repeats:false block:^(NSTimer * _Nonnull timer) {
//                  lTitle.text = self.titleString;
//                    [timer invalidate];
//                }];
//            }
            
        }
        else {
            lTitle.text = self.titleString;
        }
    }
    
    if ([event isEqualToString:kLSSocketEventOpen]) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if (self.firstRun) {
            [self convertHistoryToArray:payload[0][@"messages"]];
            self.addHeght = self.heightK;
            if (!self.chatId) {
                self.chatId = payload[0][@"id"];
            }
            self.firstRun = NO;
            if (self.dataArr.count > 4) {
                NSIndexPath *indexP = [NSIndexPath indexPathForRow:(self.dataArr.count - 1) inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }
    }
     
    
    else if ([event isEqualToString:kLSSocketEventMessage]) {
        if ([self.chatId isEqualToString:payload[0][@"chatId"]]) {
            self.insetrCell = YES;
            [self getMessage:[[DTAMessage alloc] initWithDictionary:payload[0][@"message"]]];
        }
    }
    else if ([event isEqualToString:kLSSocketEventConnect]) {
        if (!self.connectToSoket) {
            [self.socket sendEvent:kLSSocketEventOpen withPayload:@[@{@"user":self.friendId}]];
            self.connectToSoket = YES;
            self.firstRun = YES;
        };
    }
    else if ([event isEqualToString:kLSSocketEventHistory]) {
        [self addHistory:payload[0][@"messages"]];
    }
    
    
}

#pragma mark - Chat textfield
/*
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    self.userId
//    self.friendId
    [self.socket sendEvent:kLSSocketTyping withPayload:@[@{kChatSendMessageId:self.chatId, @"fromUserID": self.userId,@"toUserID": self.friendId,@"status":@true}]];
    return YES;
    
}
- (IBAction)textFieldDoneEditing:(id)sender {
    [self sendMessage];
    self.tfEntry.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (self.tfEntry.text.length > 0) {
        
    }
    
    return NO;
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];

    CGRect keyboardEndFrame;

    
    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    CGFloat diff = keyboardEndFrame.size.height - self.heightK;

    if(!self.showKyboard) {
        UIEdgeInsets tableInset = self.tableView.contentInset;
        tableInset.top += keyboardEndFrame.size.height;
       
        [self.tableView setContentInset:tableInset];
        [self.tableView setScrollIndicatorInsets:tableInset];
    
        NSDictionary* info = [aNotification userInfo];
    
        NSTimeInterval animationDuration;
    
        UIViewAnimationCurve animationCurve;
    
        CGRect keyboardFrame;
    
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
  
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
 
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];

        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardFrame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
        [UIView commitAnimations];
        
        self.heightK = keyboardEndFrame.size.height;
    }
    
    if(self.showKyboard) {
        [self showKwithHeight:diff and:aNotification];
    }
    
    self.showKyboard = YES;
    self.heightK = keyboardEndFrame.size.height;
}

- (void)showKwithHeight:(CGFloat )heightK and:(NSNotification*)aNotification {
    
    NSDictionary *userInfo = [aNotification userInfo];
    CGRect keyboardEndFrame;

    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    if(heightK > 0) {
        UIEdgeInsets tableInset = self.tableView.contentInset;
        tableInset.top += heightK;
    
        [self.tableView setContentInset:tableInset];
        
        [self.tableView setScrollIndicatorInsets:tableInset];
        
        NSDictionary* info = [aNotification userInfo];
        
        NSTimeInterval animationDuration;
        
        UIViewAnimationCurve animationCurve;
        
        CGRect keyboardFrame;
        
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y- heightK, self.view.frame.size.width, self.view.frame.size.height)];
        
        [UIView commitAnimations];
    }
    else if (heightK < 0) {
        UIEdgeInsets tableInset = self.tableView.contentInset;
        tableInset.top += heightK;
    
        [self.tableView setContentInset:tableInset];
        [self.tableView setScrollIndicatorInsets:tableInset];
        
        NSDictionary* info = [aNotification userInfo];
        
        NSTimeInterval animationDuration;
        
        UIViewAnimationCurve animationCurve;
        
        CGRect keyboardFrame;
        
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - heightK, self.view.frame.size.width, self.view.frame.size.height)];
        
        [UIView commitAnimations];
        
        self.heightK = keyboardEndFrame.size.height;
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    
    self.showKyboard = NO;

    NSDictionary* info = [aNotification userInfo];

    NSDictionary *userInfo = [aNotification userInfo];

    CGRect keyboardEndFrame;

    [userInfo[UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];

    UIEdgeInsets tableInset = self.tableView.contentInset;

    //tableInset.top -= keyboardEndFrame.size.height;
    tableInset.top = 0;
    
    [self.tableView setContentInset:tableInset];
    [self.tableView setScrollIndicatorInsets:tableInset];

    NSTimeInterval animationDuration;

    UIViewAnimationCurve animationCurve;

    CGRect keyboardFrame;
   
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
  
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + (keyboardFrame.size.height), self.view.frame.size.width, self.view.frame.size.height)];
    
    [UIView commitAnimations];
}
*/

-(void)registerForKeyboardNotifications {
    //UIKeyboardDidShowNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)freeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    
    containerView.frame = containerFrame;
    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, containerFrame.origin.y);
    
    [self scrollToBottom];
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    containerView.frame = containerFrame;
    self.tableView.frame= CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, containerFrame.origin.y);
    
    // commit animations
    [UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    containerView.frame = r;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, containerView.frame.origin.y);
    [self scrollToBottom];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    
    NSLog(@"%@",growingTextView.text);
    
    //    NSString *newString = [growingTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    //
    //    if ([newString rangeOfString:@"\n"].location != NSNotFound) {
    //        newString =[growingTextView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    }
    //
    //    if([newString isEqualToString:@""] || [newString isEqualToString:@" "]) {
    //        doneBtn.enabled=NO;
    //    } else {
    //        doneBtn.enabled=YES;
    //    }
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSLog(@"%lu",(unsigned long)growingTextView.text.length);
    
    if (growingTextView.text.length == 0) {
        if ([text isEqualToString:@" "] || [text isEqualToString:@""] || [text isEqualToString:@"\n"]) {
            doneBtn.enabled=NO;
            textView.text=@"";
            
            return NO;
        }
        doneBtn.enabled=YES;
        return YES;
    } else {
        NSLog(@"%@", self.friendId);
        [self.socket sendEvent:kLSSocketTyping withPayload:@[@{kChatSendMessageId:self.chatId, @"fromUserID": self.userId,@"toUserID": self.friendId,@"status":@true}]];
        
        doneBtn.enabled=YES;
        return YES;
    }
    return YES;
}
@end
