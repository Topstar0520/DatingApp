//
//  DTALocationManager.m
//  DatingApp
//
//  Created by Maksim on 14.09.15.
//  Copyright (c) 2015 Cleveroad Inc. All rights reserved.
//

@import CoreLocation;
#import "DTALocationManager.h"

@interface DTALocationManager () <CLLocationManagerDelegate> {
    CLLocationManager *_locManager;
    DTALocationBlock _block;
}

@end

@implementation DTALocationManager

+ (instancetype)sharedInstance {
    static DTALocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DTALocationManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];

    if(self) {
        if(NSClassFromString(@"CLLocationManager")) {
            _locManager = [CLLocationManager new];
            _locManager.delegate = self;
            _locManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            
            if ([_locManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locManager requestWhenInUseAuthorization];
            }
        }
        else {
            _locManager = nil;
        }
    }
    
    return self;
}

#pragma mark - Methods

- (void)trackLocationWithCompletionBlock:(DTALocationBlock )handler {
    if (!_locManager) {
        if(_block) {
            _block(nil);
        }
        
        return;
    }
    
    _block = handler;
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [_locManager startUpdatingLocation];
    }
    else {
        if(_block) {
            _block(nil);
        }
    }
}

#pragma mark - Locations

- (void)returnLocation:(CLLocation *)location {
    if(_block) {
        _block(location);
        _block = nil;
    }
    
    [_locManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self returnLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self returnLocation:nil];
}

@end
