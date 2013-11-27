//
//  AppDelegate.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"
#import "Networking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow* window;
@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) Networking* validToken;
@property (strong, nonatomic) UIViewController* startingview;
@property (strong, nonatomic) UIViewController* bypassLogin;
@property (strong, nonatomic) UIStoryboard* main;

+ (AppDelegate *)appDelegate;

@end
