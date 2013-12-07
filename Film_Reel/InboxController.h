//
//  InboxController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "AppDelegate.h"
#import "Reel.h"
#import "ReelView.h"

@interface InboxController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, retain   ) IBOutlet UITableView      * inboxTable;
@property (strong, retain   ) NSMutableArray   * tablearray;
@property (strong, nonatomic) UIAlertView      * error;
@property (strong, nonatomic) Networking       * inboxUpdate;
@property (strong, nonatomic) AppDelegate      * shared;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong,nonatomic ) Reel             * aReelForCell;


@end
