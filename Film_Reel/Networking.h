//
//  UserXMLParser.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface Networking : NSObject

@property(nonatomic, strong, readwrite) NSURLConnection * connection;
@property(nonatomic, strong) NSMutableData * data;

- (void) startReceive: (NSString*) defaultURL;
- (BOOL)isReceiving;
- (void) receiveDidStart;
- (void) receiveDidStopWithStatus: (NSString *) status;
- (void)stopReceiveWithStatus:(NSString *)statusString;

//delegate methods
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData;



@end
