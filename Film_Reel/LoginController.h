//
//  ViewController.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class controls the main login view. It handles the request building for logging a user in
//  and does local validation on text that is entered for username and password. It gets
//  notifications from the Networking Class and updates its view accordingly.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"
#import "Networking.h"
#import "User.h"
#import "AppDelegate.h"

@interface LoginController : UIViewController <UIAlertViewDelegate> {

}

#pragma mark Defined Objects
@property (nonatomic, strong) Networking              * loginrequest;
@property (nonatomic, strong) User                    * currentUser;

#pragma mark IBOutlets, Alerts, and Indicators
@property (nonatomic, strong) IBOutlet UIButton                * loginButton;
@property (nonatomic, strong) IBOutlet UIButton                * createButton;
@property (nonatomic, strong) IBOutlet UITextField             * usernameField;
@property (nonatomic, strong) IBOutlet UITextField             * passwordField;
@property (nonatomic, strong)          UIAlertView             * error;
@property (nonatomic, strong)          UIActivityIndicatorView * indicator;

///////////////////////////////////////////////////////////////////////////

#pragma mark Action Handlers
- (IBAction) doLoginButton:  (id) sender;
- (IBAction) doCreateButton: (id) sender;

#pragma mark Network Handlers
- (NSString*) buildLoginRequest: (NSString*) name withPassword: (NSString*) password;
- (void) didGetNetworkError:     (NSNotification*) notif;
- (void) didSucceedRequest:      (NSNotification*) notif;

#pragma mark Textfeild and validation methods
- (void) shouldAutoFillFields: (NSNotification*) notif;
- (BOOL) validateUserNameWithString: (NSString*) username;
- (BOOL) validatePasswordWithString: (NSString*) pass;

@end
