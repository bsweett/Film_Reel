//
//  UserXMLParser.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "User.h"

@interface Networking : NSObject <NSXMLParserDelegate>

@property(nonatomic, strong, readwrite) NSURLConnection * connection;
@property(nonatomic, strong) NSMutableData * data;
@property(nonatomic, strong) NSXMLParser* parser;
@property(nonatomic, strong) NSString* requestType;
@property(nonatomic, strong) User* userObject;
@property(nonatomic, strong) NSMutableString* currentObject;
@property(nonatomic, strong) NSMutableDictionary *dataReceived;

- (void) startReceive: (NSString*) defaultURL withType: (NSString*) typeOfRequest;
- (BOOL)isReceiving;
- (void) receiveDidStart;
- (void) receiveDidStopWithStatus: (NSString *) status;
- (void)stopReceiveWithStatus:(NSString *)statusString;

//delegate methods
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData;

-(void)saveImageToServer: (NSData*) dataImage withPostType: (NSString*) postType;

@end
