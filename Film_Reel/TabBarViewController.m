//
//  TabBarViewController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-20.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This view controller is mostly empty. It is used to control the tab bar. Each of the tab views
//  has its own controller. See: FriendController, CameraController, InboxController, and
//  ProfileController.

#import "TabBarViewController.h"
#import "Networking.h"

@interface TabBarViewController ()
@end

@implementation TabBarViewController

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


/**
 * This method is called when the Tabbar Controller is loaded for the first
 * time. It sets the starting tab and adjusts the tabbar appearance
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor lightGrayColor],
                                                       NSForegroundColorAttributeName,
                                                       nil]
                                             forState:UIControlStateNormal];
    self.selectedIndex = 2;
}


/**
 * Handles any memory warnings sent from the OS
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
