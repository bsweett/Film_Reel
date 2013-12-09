//
//  SelectFriendController.h
//  Film_Reel
//
//  Created by Ben Sweett on 11/29/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This view controller is only accessible from the CameraController / Take a Reel Tab. It contains
//  a tableview with all of the users friends. If the user selects one this class will upload the
//  reel and then make a SendReel request to the server with some information.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"

@interface SelectFriendController : UITableViewController <UITableViewDataSource,
    UITableViewDelegate>

#pragma mark Defined Objects
@property (nonatomic, strong) Networking      *sendReelRequest;
@property (nonatomic, strong) AppDelegate     * shared;

#pragma mark UIAlerts
@property (nonatomic, strong) UIAlertView     *alert;

#pragma mark Varaibles for Table and Sending
@property (nonatomic, strong) NSArray         * tableElements;
@property (nonatomic, strong) NSData          * imageToSend;
@property (nonatomic, strong) NSString        * selectedFriend;
@property (nonatomic, strong) NSString        * sendersEmail;
@property (nonatomic, strong) NSString        * recepient;
@property (nonatomic, strong) NSMutableString * ImageFileName;

///////////////////////////////////////////////////////////////////////////

#pragma mark Network Handlers
- (void) didSucceedRequest: (NSNotification*) notif;
- (void) didGetNetworkError: (NSNotification*) notif;

#pragma mark String building
- (NSString*) buildImageFileName: (NSString*) recipient;
- (NSString*) buildSendRequest:   (NSString*) sender withFriend: (NSString*) receiver
                                              withImageFileName: (NSString*) imageName;

#pragma mark -
#pragma mark NOTE:: Also contains TableView Datasource and Delegate
#pragma mark -

@end
