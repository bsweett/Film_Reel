//
//  SignUpCompleteController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "User.h"
#import "AppDelegate.h"

@interface SignUpCompleteController : UIViewController

@property (nonatomic, strong) NSString* loginUsername;
@property (nonatomic, strong) NSString* loginPassword;

-(IBAction) doLogIn:(id) sender;

@end
