//
//  DTAConversationsViewController.m
//  DatingApp
//
//  Created by VLADISLAV KIRIN on 8/3/15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

#import "DTAConversationsViewController.h"
#import "DTAChatViewController.h"
#import "DTASocket.h"
#import "DTAconversation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DTAConversationsTableViewCell.h"
#import "User+Extension.h"

@interface DTAConversationsViewController () <UITableViewDelegate, UITableViewDataSource, DTASocketIOServiceDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DTASocket *socket;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *hiddenConversationArr;
@property (nonatomic, strong) NSIndexPath *deletrRow;

@end

@implementation DTAConversationsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = colorCreamCan;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName :[UIColor whiteColor]};

    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    self.socket = [DTASocket sharedInstance];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogOut) name:@"userLogOut" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSocketWithTocken) name:@"connectSocketWithTocken" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(badgeUpdate) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.hiddenConversationArr = [NSMutableArray new];
    
    [self.socket addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.dataArr = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    APP_DELEGATE.hud = [[SAMHUDView alloc] initWithTitle:nil];
    [APP_DELEGATE.hud show];
    
    if (self.socket.connectToSoket) {
        [self.socket disconnect];
    }
    
    [self.socket connect];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)connectSocketWithTocken {
    
    if (self.socket.connectToSoket) {
        [self.socket disconnect];
    }
    
    [self.socket connect];
}

- (void)userLogOut {
    [self.socket disconnect];

    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (APP_DELEGATE.firstRun) {
        id loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DTARegisterNavigationControllerID"];
        [self presentViewController:loginVC animated:YES completion:nil];
        APP_DELEGATE.firstRun = NO;
    }
    
    [self badgeUpdate];
}

- (void)badgeUpdate {
    [DTAAPI badgeUpdateWithPushType:DTAPushNewMessages сompletion:^(NSError *error) {
        [User currentUser].messagesBadge = @0;
        NSInteger badgeNumber = [[User currentUser].likesBadge integerValue] + [[User currentUser].matchesBadge integerValue];
        [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    }];
}

#pragma mark - TableViewDelegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"data arr count %lu", (unsigned long)self.dataArr.count);
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 80 * SCREEN_WIDTH / 375.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DTAConversationsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DTAChatCell" forIndexPath:indexPath];
    
    DTAconversation *conversation = self.dataArr[indexPath.row];
    NSLog(@"conversation data = %@", conversation);
    [cell configureWithUser:conversation];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Do you want delete conversation?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            DTAconversation *convers = self.dataArr[indexPath.row];
            [self.socket sendEvent:kLSSocketEventClearHistory withPayload:@[@{@"chatId":convers.chatId}]];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:yesAction];
        [alertController addAction:noAction];
        
        [self.navigationController presentViewController:alertController animated:yesAction completion:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"showChat" sender:self];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)removeConversation {
    
    DTAconversation *convers = self.dataArr[self.deletrRow.row];
    convers.lastTextMessage = @"";
    [self.hiddenConversationArr addObject:convers];
    [self.dataArr removeObject:convers];
    [self.tableView reloadData];
}

#pragma mark - DTASocketIOService Delegate

- (void)socketServiceDidDisconnect:(DTASocket *)service {
    [self.dataArr removeAllObjects];
    [self.tableView reloadData];
}

- (void)socketService:(DTASocket *)service didReceiveEvent:(NSString *)event withPayload:(NSArray *)payload {
    
    if ([event isEqualToString:kLSSocketEventConnect]) {
        
        NSMutableArray *tempDataArray = [NSMutableArray new];
        NSMutableArray *tempHiddenConversArray = [NSMutableArray new];
        
        for (NSDictionary *dict in [payload[0] objectForKey:@"chats"]) {
            
            DTAconversation *conversation = [[DTAconversation alloc] initWithDictionary:dict];
            
            if (conversation.lastTextMessage.length > 0) {
                if (conversation.blocked == YES) {
                    [tempHiddenConversArray addObject:conversation];
                }
                else {
                    if (conversation.is_matched == YES) {
                        [tempDataArray addObject:conversation];
                    }
                    else {
                        [tempHiddenConversArray addObject:conversation];
                    }
                }
            }
            else {
                [tempHiddenConversArray addObject:conversation];
            }
        }
        
        NSArray *sortedArray;
        
        sortedArray = [tempDataArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            
            double first = [(DTAconversation* )a date];
            double second = [(DTAconversation* )b date];
        
            if (first > second) {
                return NO;
            }
            else {
                return YES;
            }
        }];
        
        self.dataArr = nil;
        self.dataArr = [[NSMutableArray alloc] initWithArray:sortedArray];
        
        self.hiddenConversationArr = nil;
        self.hiddenConversationArr = tempHiddenConversArray;
        
        [self.tableView reloadData];
        
        [APP_DELEGATE.hud dismiss];
    }
    else if([event isEqualToString:kLSSocketEventMessage]) {
        [self updateConversationTable:payload[0]];
    }
    else if([event isEqualToString:kLSSocketEventOpen]) {
        [self insertNewChatRomDictionary:payload[0]];
    }
    else if ([event isEqualToString:kLSSocketEventClearHistory]) {
        [self removeConversation];
    }
    else if ([event isEqualToString:kLSSocketEventProfileRemoved] || [event isEqualToString:kLSSocketEventProfileBlocked] || [event isEqualToString:kLSSocketEventRemoveChatBlocked]) {
        [self handleRemovedCompanionWithPayload:payload[0]];
    }
}

#pragma mark -

- (void)insertNewChatRomDictionary:(NSDictionary *)dictionary {
    
    NSString *idChat = dictionary[@"id"];
    BOOL sameId = NO;
    
    for (DTAconversation *conversation in self.dataArr) {
        if([idChat isEqualToString:conversation.chatId]) {
            sameId = YES;
        }
    }
    
    if(!sameId) {
        
        DTAconversation *conversation = [[DTAconversation alloc] initWithDictionary:dictionary];
    
        if(conversation.date == 0) {
            conversation.date = [[NSDate date] timeIntervalSince1970];
        }
        
        if(conversation.lastTextMessage.length > 0) {
            [self.dataArr insertObject:[[DTAconversation alloc] initWithDictionary:dictionary] atIndex:0];
            [self.tableView reloadData];
        }
        else {
            conversation.date = 0;
            conversation.date = [[NSDate date] timeIntervalSince1970];
            [self.hiddenConversationArr addObject:conversation];
        }
    }
}

- (void)updateConversationTable:(NSDictionary *)dict {
    BOOL stop = NO;

    for (DTAconversation *convers in self.dataArr) {
        if([convers.chatId isEqualToString:dict[@"chatId"]]) {
            
            DTAconversation *topConwers = convers;
            topConwers.lastTextMessage = dict[@"message"][@"message"];
            topConwers.date = 0;
            topConwers.date = [[NSDate date] timeIntervalSince1970];
            [self.dataArr removeObject:convers];
            [self.dataArr insertObject:topConwers atIndex:0];
            [self.tableView reloadData];
            stop = YES;
            break;
        }
    }
    
    if(!stop) {
        for (DTAconversation *convers in self.hiddenConversationArr) {
            if([convers.chatId isEqualToString:dict[@"chatId"]]) {
                
                DTAconversation *topConwers = convers;

                topConwers.lastTextMessage = dict[@"message"][@"message"];
                topConwers.date = 0;
                topConwers.date = [[NSDate date] timeIntervalSince1970];
                [self.dataArr insertObject:topConwers atIndex:0];
                [self.tableView reloadData];
                stop = YES;
                break;
            }
        }
    }
}

- (void)handleRemovedCompanionWithPayload:(NSDictionary *)dictionary {
    
    NSString *friendId = dictionary[@"userId"];

    for (DTAconversation *conversation in self.dataArr) {
        if ([conversation.idFriend isEqualToString:friendId]) {
            conversation.isFriendDeleted = YES;
            [self.tableView reloadData];
            break;
        }
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showChat"]) {
        DTAChatViewController *destVC = segue.destinationViewController;
        NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
        DTAconversation *conversation = self.dataArr[ip.row];
        destVC.titleString = conversation.nameAge;
        destVC.chatId = conversation.chatId;
        destVC.userId = conversation.idUser;
        destVC.friendId = conversation.idFriend;
        destVC.isFriendDeleted = conversation.isFriendDeleted;
    }
}

@end
