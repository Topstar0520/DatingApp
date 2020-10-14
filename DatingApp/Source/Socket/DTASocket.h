//
//  DTASocket.h
//  DatingApp
//
//  Created by Maksim on 12.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kLSSocketTyping;

extern NSString * const kLSSocketEventError;
extern NSString * const kLSSocketEventConnect;
extern NSString * const kLSSocketEventHistory;
extern NSString * const kLSSocketEventMessage;
extern NSString * const kLSSocketEventOpen;
extern NSString * const kLSSocketEventClearHistory;
extern NSString * const kLSSocketEventProfileRemoved;
extern NSString * const kLSSocketEventProfileBlocked;
extern NSString * const kLSSocketEventRemoveChatBlocked;

@class DTASocket;

@protocol DTASocketIOServiceDelegate <NSObject>

@optional

- (void)socketServiceDidConnect:(DTASocket *)service;
- (void)socketServiceDidDisconnect:(DTASocket *)service;

- (void)socketService:(DTASocket *)service didFailedWithError:(NSError *)error;
- (void)socketService:(DTASocket *)service didReceiveEvent:(NSString *)event withPayload:(NSArray *)payload;

@end

@interface DTASocket : NSObject

@property (nonatomic, readonly) BOOL connectToSoket;
@property (nonatomic, weak) id<DTASocketIOServiceDelegate>delegate;

+ (instancetype)sharedInstance;

- (void)connectWebSocketWithTocken:(NSString *)tocken;
- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;

- (void)sendEvent:(NSString *)event withPayload:(NSArray *)payload;

- (void)connect;
- (void)setupEventsHandler;
- (void)disconnect;

@end
