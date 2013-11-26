//
//  SignUpEmailController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"

@interface SignUpEmailController : UIViewController <UIAlertViewDelegate>

// Types
@property(nonatomic, strong) IBOutlet UITextField *emailField;
@property(nonatomic, strong) IBOutlet UITextField *userField;
@property(nonatomic, strong) IBOutlet UITextField *passField;
@property(nonatomic, strong) IBOutlet UINavigationItem *titlebar;
@property (strong, nonatomic) IBOutlet UITextField *passConfirm;
@property(nonatomic, strong) UIAlertView* error;
@property(nonatomic, strong) UIActivityIndicatorView *indicator;
@property(nonatomic, strong) Networking * userRequest;

// Actions
-(IBAction)doNextButton:(id)sender;

// General
- (NSString*) buildSignUpRequest: (NSString*) email withName: (NSString*) name withPassword: (NSString*) password;
-(void) didGetNetworkError: (NSNotification*) notif;
-(void) dismissErrors:(UIAlertView*) alert;
-(void) didSucceedRequest: (NSNotification*) notif;
- (BOOL) textFieldShouldReturn:(UITextField*) textField;

// Validatations
- (BOOL)validateEmailWithString:(NSString*)emailaddress;
- (BOOL)validateUserNameWithString:(NSString*)user;
- (BOOL)validatePasswordWithString:(NSString*)pass withCPass: (NSString*) cpass;

@end
