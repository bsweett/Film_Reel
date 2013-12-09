//
//  InboxController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This view controller is used to controller the inbox tab. It contains a tableview and will
//  refresh a persons inbox if they pull down on it. Tapping on a cell in the inbox with data
//  will open a detail view for viewing the reel that was send to them.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"
#import "Reel.h"
#import "ReelView.h"

@interface InboxController : UIViewController <UITableViewDelegate,
    UITableViewDataSource>

#pragma mark Defined Objects
@property (strong, nonatomic) Networking       * inboxUpdate;
@property (strong, nonatomic) AppDelegate      * shared;
@property (strong, nonatomic) Reel             * aReelForCell;

#pragma mark TableView elements
@property (strong, retain   ) IBOutlet UITableView      * inboxTable;
@property (strong, retain   )       NSMutableArray      * tablearray;

#pragma mark Alerts and Refresh
@property (strong, nonatomic)          UIAlertView      * error;
@property (strong, nonatomic)      UIRefreshControl     * refreshControl;

///////////////////////////////////////////////////////////////////////////

#pragma Network Handlers
-(void) didSucceedRequest: (NSNotification*) notif;
-(void) didGetNetworkError: (NSNotification*) notif;
- (void)refresh;
- (NSString*) buildInboxRequest: (NSString*) token;

#pragma mark -
#pragma mark NOTE:: Also contains TableView Datasource and Delegate
#pragma mark -

@end
