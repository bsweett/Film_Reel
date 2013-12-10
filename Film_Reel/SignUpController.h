//
//  SignUpEmailController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Handles proper account creation. Sends data to server to check if the user exists or not.
//
//  TODO:: let them optional fill in gender, location etc..
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "SignUpCompleteController.h"
#import "User.h"

@interface SignUpController : UIViewController <UIAlertViewDelegate>

#pragma mark Defined Objects
@property (nonatomic, strong) Networking          * userRequest;
@property (nonatomic, strong) User                * newlyMadeUser;

#pragma mark IBOutlets and UI elements
@property (nonatomic, strong) IBOutlet UITextField             * emailField;
@property (nonatomic, strong) IBOutlet UITextField             * userField;
@property (nonatomic, strong) IBOutlet UITextField             * passField;
@property (nonatomic, strong) IBOutlet UINavigationItem        * titlebar;
@property (strong, nonatomic) IBOutlet UITextField             * passConfirm;
@property (nonatomic, strong) UIAlertView                      * error;
@property (nonatomic, strong) UIActivityIndicatorView          * indicator;

///////////////////////////////////////////////////////////////////////////

#pragma mark Create Action
-(IBAction)doNextButton:(id)sender;

#pragma mark Network Handles
- (void) didGetNetworkError: (NSNotification*) notif;
- (void) didSucceedRequest: (NSNotification*) notif;
- (BOOL) textFieldShouldReturn:(UITextField*) textField;

#pragma String building and checking
- (BOOL)validateEmailWithString:(NSString*)emailaddress;
- (BOOL)validateUserNameWithString:(NSString*)user;
- (BOOL)validatePasswordWithString:(NSString*)pass withCPass: (NSString*) cpass;
- (NSString*) buildSignUpRequest: (NSString*) email withName: (NSString*) name withPassword: (NSString*) password;

@end
