//
//  NetworkManager.h
//  DAY2_URLREADER
//
//  Created by Ben Sweett on 2013-09-11.
//  Copyright (c) 2013 Ben Sweett - 100846396. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (NSURL *)smartURLForString:(NSString *)str;

- (void)didStartNetworkOperation;

- (void)didStopNetworkOperation;

@end
