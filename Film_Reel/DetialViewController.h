//
//  DetialViewController.h
//  Film_Reel
//
//  Created by Brayden Girard on 12/1/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This is a detail view that is called when a user selects a friend's name from the list.
//  On load grab user data before displaying thier profile.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Networking.h"

@interface DetialViewController : UIViewController

#pragma mark Defined Objects
@property (strong, nonatomic) User                    * friendUser;
@property (strong, nonatomic) Networking              * getProfile;

#pragma mark IBOutlets, Alerts, and Indicators
@property (strong, nonatomic) IBOutlet UITextView              *name;
@property (strong, nonatomic) IBOutlet UITextView              *email;
@property (strong, nonatomic) IBOutlet UIImageView             *displayPicture;
@property (strong, nonatomic) IBOutlet UITextView              *bio;
@property (strong, nonatomic) IBOutlet UITextView              *location;
@property (strong, nonatomic) IBOutlet UITextView              *reelCount;
@property (strong, nonatomic) IBOutlet UIImageView             *male;
@property (strong, nonatomic) IBOutlet UIImageView             *female;
@property (strong, nonatomic) IBOutlet UIImageView             *friendstar1;
@property (strong, nonatomic) IBOutlet UIImageView             *friendstar2;
@property (strong, nonatomic) IBOutlet UIImageView             *friendstar3;
@property (strong, nonatomic) IBOutlet UIImageView             *friendstar4;
@property (strong, nonatomic) IBOutlet UIImageView             *friendstar5;
@property (strong, nonatomic) UIAlertView             * error;
@property (strong, nonatomic) UIActivityIndicatorView * indicator;

#pragma mark Other variables
@property (strong, nonatomic) NSString                *friendEmail;

///////////////////////////////////////////////////////////////////////////

#pragma mark Network Handlers
- (void) didGetNetworkError: (NSNotification*) notif;
- (void) didSucceedRequest: (NSNotification*) notif;

#pragma mark Other methods
- (void) setPopStars: (NSMutableString*) popular;
- (NSString*) buildFriendDataRequest: (NSString*) anEmail;

@end
