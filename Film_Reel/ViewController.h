//
//  ViewController.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_ENTRY_SIZE 4
#define MAX_USERNAME_ENTRY 29
#define MAX_PASSWORD_ENTRY 12

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UIButton *loginButton;
@property(nonatomic, retain) IBOutlet UIButton *createButton;
@property(nonatomic, retain) IBOutlet UITextField *usernameField;
@property(nonatomic, retain) IBOutlet UITextField *passwordField;
@property(nonatomic, retain) UIAlertView* error;

// Validatation
- (BOOL)validateUserNameWithString:(NSString*)username;
- (BOOL)validatePasswordWithString:(NSString*)pass;

@end
