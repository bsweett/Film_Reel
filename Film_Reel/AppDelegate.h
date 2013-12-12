//
//  AppDelegate.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Main control point for application
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "LoginController.h"
#import "TabBarViewController.h"
#import "Networking.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

#pragma mark Defined Objects
@property (strong, nonatomic) User             * appUser;
@property (strong, nonatomic) Networking       * validToken;

#pragma mark Application Views
@property (strong, nonatomic) UIWindow         * window;
@property (strong, nonatomic) UIViewController * startingview;
@property (strong, nonatomic) UIViewController * bypassLogin;
@property (strong, nonatomic) UIStoryboard     * main;

#pragma mark Other
@property (strong, nonatomic) NSString         *isTokenValid;

///////////////////////////////////////////////////////////////////////////

#pragma mark Ulitity
- (UIColor*)colorWithHexString:(NSString*)hex;
+ (AppDelegate *)appDelegate;

#pragma mark Network Handlers
- (NSString*) buildTokenLoginRequest: (NSString*) tokenToCheck;
-(void) didGetNetworkError: (NSNotification*) notif;
-(void) didSucceedRequest: (NSNotification*) notif;

@end
