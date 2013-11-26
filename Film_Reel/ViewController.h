//
//  ViewController.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Networking.h"
#import "User.h"

@interface ViewController : UIViewController <UIAlertViewDelegate> {
    //AppDelegate* app;
}

@property(nonatomic, strong) IBOutlet UIButton *loginButton;
@property(nonatomic, strong) IBOutlet UIButton *createButton;
@property(nonatomic, strong) IBOutlet UITextField *usernameField;
@property(nonatomic, strong) IBOutlet UITextField *passwordField;
@property(nonatomic, strong) UIAlertView* error;
@property(nonatomic, strong) UIActivityIndicatorView* indicator;
@property(nonatomic, strong) Networking* loginrequest;
@property(nonatomic, strong) User* currentUser;

// Validatation
- (BOOL)validateUserNameWithString:(NSString*)username;
- (BOOL)validatePasswordWithString:(NSString*)pass;

@end
