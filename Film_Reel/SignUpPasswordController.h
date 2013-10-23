//
//  SignUpPasswordController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

#define MIN_PASS_ENTRY 8
#define MAX_PASSWORD_ENTRY 20

@interface SignUpPasswordController : UIViewController <UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITextField *passField;
@property(nonatomic, strong) UIAlertView* error;

// Validatation
- (BOOL)validatePasswordWithString:(NSString*)pass;


@end
