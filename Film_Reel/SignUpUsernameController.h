//
//  SignUpUsernameController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_ENTRY_SIZE 4
#define MAX_USERNAME_ENTRY 30

@interface SignUpUsernameController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITextField *userField;
@property(nonatomic, strong) UIAlertView* error;

// Validatation
- (BOOL)validateUserNameWithString:(NSString*)user;

@end
