//
//  FriendsController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"
#import "DetialViewController.h"

@interface FriendsController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (strong, retain) IBOutlet UITableView* friendsTable;
@property (strong, nonatomic) NSMutableArray* tableArray;
@property (strong, nonatomic) UIAlertView* addfriendalert;
@property (strong, nonatomic) UIAlertView* loading;
@property (strong, nonatomic) User *userdata;
@property (strong, nonatomic) Networking* friendRequest;
@property (strong, nonatomic) AppDelegate* shared;
@property (strong, nonatomic) NSArray *tableElements;

-(IBAction)doAddFriend:(id)sender;
-(void) didSucceedRequest: (NSNotification*) notif;
-(void) didGetNetworkError: (NSNotification*) notif;


@end
