//
//  DTASocket.m
//  DatingApp
//
//  Created by Maksim on 12.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import "DTASocket.h"
#import "SIOSocket.h"
#import "GCDMulticastDelegate.h"
#import "DTASocketIOServiceDelegate.h"

NSString * const kLSSocketEventError = @"err";
NSString * const kLSSocketEventConnect = @"connected";
NSString * const kLSSocketEventHistory = @"chatHistory";
NSString * const kLSSocketEventMessage = @"chatMessage";
NSString * const kLSSocketEventOpen = @"chatOpen";
NSString * const kLSSocketTyping = @"typing";
//NSString * const kLSSocketDisplay = @"display";
NSString * const kLSSocketEventClearHistory = @"chatClearHistory";
NSString * const kLSSocketEventProfileRemoved = @"profileRemoved";
NSString * const kLSSocketEventProfileBlocked = @"profileBlocked";
NSString * const kLSSocketEventRemoveChatBlocked = @"chatRemoved";

@interface DTASocket ()

@property (nonatomic, strong) SIOSocket *socket;
@property (nonatomic, strong) DTASocketIOServiceDelegate *multicastDelegate;
@property (nonatomic, strong) NSString *tocken;

@end

@implementation DTASocket

+ (instancetype)sharedInstance {
    
    static DTASocket *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTASocket alloc] init];
        
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _connectToSoket = NO;
    }
    
    return self;
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    
    if([delegate conformsToProtocol:NSProtocolFromString([self delegateProtocol])]) {
        [self.multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
    }
}

- (void)removeDelegate:(id)delegate {
    if([delegate conformsToProtocol:NSProtocolFromString([self delegateProtocol])]) {
        [self.multicastDelegate removeDelegate:delegate];
    }
}

- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue {
    if([delegate conformsToProtocol:NSProtocolFromString([self delegateProtocol])]) {
        [self.multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
    }
}

- (NSString *)delegateProtocol {
    return @"DTASocketIOServiceDelegate";
}

- (void)disconnect {
    [self.socket close];

    self.socket = nil;
    _connectToSoket = NO;
}

- (void)connect {
    
    __weak typeof(self) weakSelf = self;

    NSLog(@"self.tocken = %@", self.tocken);
    
    [SIOSocket socketWithHost:self.tocken response:^(SIOSocket *socket) {
        
        if(socket) {
            weakSelf.socket = socket;
            [weakSelf setupSocketEvents];
        }
        else {
            _connectToSoket = NO;
        }
    }];
}

- (void)connectWebSocketWithTocken:(NSString *)tocken {
    
    NSString *socketURLString = [NSString stringWithFormat:@"%@?accessToken=%@", DTAAPIServerHostname, tocken];
    self.tocken = socketURLString;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectSocketWithTocken" object:nil];
}

- (void)setupSocketEvents {
    if(!_connectToSoket)
    {
        [self setupConnectHandler];
        [self setupErrorHandler];
        [self setupEventsHandler];
    
        _connectToSoket = YES;
    }
}

- (void)setupErrorHandler {
    __weak typeof(self) weakSelf = self;

    self.socket.onError = ^(NSDictionary *errorInfo) {
        //TODO: Add error
        [weakSelf.multicastDelegate socketService:weakSelf didFailedWithError:nil];
        NSLog(@"%@ connection error %@", weakSelf, errorInfo);
    };
}

- (void)setupConnectHandler {
    __weak typeof(self) weakSelf = self;

    self.socket.onConnect = ^() {
        [weakSelf.multicastDelegate socketServiceDidConnect:weakSelf];
        NSLog(@"%@ connected", weakSelf);
    };
}

- (void)setupDisconnectHandler {
    __weak typeof(self) weakSelf = self;

    self.socket.onDisconnect = ^() {
        [weakSelf.multicastDelegate socketServiceDidDisconnect:weakSelf];
    };
}

- (void)setupEventsHandler {
    
    __weak typeof(self) weakSelf = self;

    [self.socket on:kLSSocketTyping callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketTyping withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventConnect callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventConnect withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventHistory callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventHistory withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventMessage callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventMessage withPayload:args];
    }];

    [self.socket on:kLSSocketEventOpen callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventOpen withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventClearHistory callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventClearHistory withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventProfileRemoved callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventProfileRemoved withPayload:args];
    }];
    
    [self.socket on:kLSSocketEventProfileBlocked callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventProfileBlocked withPayload:args];
    }];
  
    [self.socket on:kLSSocketEventRemoveChatBlocked callback:^(SIOParameterArray *args) {
        [weakSelf notifyOnEvent:kLSSocketEventRemoveChatBlocked withPayload:args];
    }];
}

- (void)notifyOnEvent:(NSString *)event withPayload:(NSArray *)payload {
    [self.multicastDelegate socketService:self didReceiveEvent:event withPayload:payload];
}

- (GCDMulticastDelegate *)multicastDelegate {
    if(!_multicastDelegate) {
        _multicastDelegate = [[DTASocketIOServiceDelegate alloc] init];
    }
    
    return _multicastDelegate;
}

- (void)sendEvent:(NSString *)event withPayload:(NSArray *)payload {
    NSLog(@"socket %@ sent event \'%@\' with payload: %@", self, event, payload);
    [self.socket emit:event args:payload];
//    [self.socket emit:event args:payload ack:^(SIOParameterArray *arr) {
//    }];
}
@end
