//
//  FriendsController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This controller handles a users friend list view in the tabbar. It allows user to add friends
//  and select them to view thier profiles.
//

//  TODO:: Allow removal of friends from list

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"
#import "DetialViewController.h"

@interface FriendsController : UIViewController <UITableViewDelegate,
    UITableViewDataSource, UIAlertViewDelegate, UINavigationBarDelegate>

#pragma mark Defined Objects
@property (strong, nonatomic) User           *userdata;
@property (strong, nonatomic) Networking     * friendRequest;
@property (strong, nonatomic) AppDelegate    * shared;

#pragma mark Table Array Elements
@property (strong, retain   ) IBOutlet UITableView    * friendsTable;
@property (strong, nonatomic) NSMutableArray * tableArray;
@property (strong, nonatomic) NSArray        *tableElements;

#pragma mark Alerts
@property (strong, nonatomic) UIAlertView    * addfriendalert;
@property (strong, nonatomic) UIAlertView    * loading;
 
///////////////////////////////////////////////////////////////////////////

#pragma mark Add Friend Action
-(IBAction) doAddFriend:(id)sender;

#pragma mark Network Handlers
-(void) didSucceedRequest: (NSNotification*) notif;
-(void) didGetNetworkError: (NSNotification*) notif;

#pragma mark String building
- (NSString*) buildAddRequest: (NSString*) friendToAdd withToken: (NSString*) thisUser;
- (BOOL) validateEmailWithString:(NSString*)emailaddress;

#pragma mark -
#pragma mark NOTE:: Also contains TableView Datasource and Delegate
#pragma mark -

#pragma mark -
#pragma mark NOTE:: Also contains AlertView Delegate
#pragma mark -

@end
