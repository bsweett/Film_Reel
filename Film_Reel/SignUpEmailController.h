//
//  SignUpEmailController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_EMAIL_ENTRY 2
#define MAX_EMAIL_ENTRY 255

@interface SignUpEmailController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, retain) IBOutlet UITextField *emailField;
@property(nonatomic, retain) UIAlertView* error;

// Validatation
- (BOOL)validateEmailWithString:(NSString*)emailaddress;

@end
