//
//  SignUpEmailController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_EMAIL_ENTRY 3
#define MAX_EMAIL_ENTRY 254

@interface SignUpEmailController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITextField *emailField;
@property(nonatomic, strong) UIAlertView* error;

// Validatation
- (BOOL)validateEmailWithString:(NSString*)emailaddress;

@end
