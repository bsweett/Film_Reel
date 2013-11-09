//
//  SignUpEmailController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"

#define MIN_EMAIL_ENTRY 3
#define MAX_EMAIL_ENTRY 254
#define MIN_ENTRY_SIZE 4
#define MAX_USERNAME_ENTRY 30
#define MIN_PASS_ENTRY 8
#define MAX_PASSWORD_ENTRY 20

@interface SignUpEmailController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITextField *emailField;
@property(nonatomic, strong) IBOutlet UITextField *userField;
@property(nonatomic, strong) IBOutlet UITextField *passField;
@property(nonatomic, strong) UIAlertView* error;
@property(nonatomic, strong) UIAlertView* loading;
@property(nonatomic, strong) Networking * userRequest;

// Validatation
- (BOOL)validateEmailWithString:(NSString*)emailaddress;
- (BOOL)validateUserNameWithString:(NSString*)user;
- (BOOL)validatePasswordWithString:(NSString*)pass;

@end
