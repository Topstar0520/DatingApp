//
//  DTASocketIOServiceDelegate.h
//  DatingApp
//
//  Created by Maksim on 12.10.15.
//  Copyright © 2015 Cleveroad Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDMulticastDelegate.h"
#import "DTASocket.h"

@protocol DTASocketIOServiceDelegate;

@interface DTASocketIOServiceDelegate : GCDMulticastDelegate <DTASocketIOServiceDelegate>

@end
