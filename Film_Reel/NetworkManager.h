//
//  NetworkManager.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Manages Networking thread and parsers URL string into a proper URL format
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (NetworkManager *)sharedInstance;

- (NSURL *)smartURLForString:(NSString *)str;

- (void)didStartNetworkOperation;

- (void)didStopNetworkOperation;

@end
