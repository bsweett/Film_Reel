//
//  UserXMLParser.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class handles all of the networking operations, requests, and uploading. It sends
//  notifications to the view controllers based on what is prasered from the XML Data that
//  is returned from the server.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "User.h"
#import "Reel.h"

@interface Networking : NSObject <NSXMLParserDelegate>

#pragma mark Define Objects
@property (nonatomic, strong           ) User                * userObject;
@property (nonatomic, strong           ) Reel                * reelObject;

#pragma mark Variables
@property (nonatomic, strong, readwrite) NSURLConnection     * connection;
@property (nonatomic, strong           ) NSMutableData       * data;
@property (nonatomic, strong           ) NSXMLParser         * parser;
@property (nonatomic, strong           ) NSString            * requestType;
@property (nonatomic, strong           ) NSMutableArray      * reelArray;
@property (nonatomic, strong           ) NSMutableString     * currentObject;
@property (nonatomic, strong           ) NSMutableDictionary *dataReceived;

///////////////////////////////////////////////////////////////////////////

#pragma mark URL & Connection Control
- (void) startReceive: (NSString*) defaultURL withType: (NSString*) typeOfRequest;
- (BOOL) isReceiving;
- (void) receiveDidStart;
- (void) receiveDidStopWithStatus: (NSString *) status;
- (void) stopReceiveWithStatus:(NSString *)statusString;

#pragma mark Valid Request Functions
- (void) isValidLoginRequest: (NSString*) localMessage;
- (void) isValidFriendRequest: (NSString*) localMessage;
- (void) isValidSignUpRequest: (NSString*) localMessage;
- (void) isValidUpdateRequest: (NSString*) localMessage;
- (void) isValidTokeLoginRequest: (NSString*) localMessage;
- (void) isValidDataRequest: (NSString*) localMessage;
- (void) isValidInboxRequest: (NSString*) localMessage;
- (void) isValidReelRequest: (NSString*) localMessage;

#pragma mark Spilting Data Functions 
- (void)seperateFriends:(NSString *)friendsString andUser: (User *)user;
- (NSMutableArray *)seperateReelData:(NSString*)reelString;

#pragma mark Image Uploading and Downloading
-(void)saveImageToServer: (NSData*) dataImage withFileName: (NSString*) filename;
-(UIImage *) downloadImageFromServer: (NSString *) url;

#pragma mark -
#pragma mark NOTE:: Also contains NSURLConnnection Delegate
#pragma mark -

#pragma mark -
#pragma mark NOTE:: Also contains NSXMLParser Delegate
#pragma mark -

@end
