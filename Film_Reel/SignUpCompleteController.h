//
//  SignUpCompleteController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This controller doesnt do much. It is a view to tell the user they have an account now. Redirects
//  them and thier new login data to the log in screen.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "User.h"
#import "AppDelegate.h"

@interface SignUpCompleteController : UIViewController

#pragma mark Local Login Data
@property (nonatomic, strong) NSString * loginUsername;
@property (nonatomic, strong) NSString * loginPassword;

///////////////////////////////////////////////////////////////////////////

#pragma mark Actions
-(IBAction) doLogIn:(id) sender;

@end
