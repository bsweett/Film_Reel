//
//  SignUpCompleteController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This controller doesnt do much. It is a view to tell the user they have an account now. Redirects
//  them and thier new login data to the log in screen.
//

#import "SignUpCompleteController.h"

@interface SignUpCompleteController ()

@end

@implementation SignUpCompleteController

@synthesize loginPassword;
@synthesize loginUsername;

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
 * This method is called when the SignUpCompleteController is loaded for the first
 * time. Sets nav bar properties. 
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
}


/**
 * Handles any memory warnings sent from the OS
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    LogDebug(@"Memory Warning");
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Actions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * When login button is pressed store login data. Send AUTO_FILL notification
 * and pop to the root view.
 *
 * @param sender This segue will be called from this view controller (self)
 */
-(IBAction) doLogIn:(id) sender
{
    NSDictionary* newUserDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                       loginUsername, @CACHED_NEW_USER,
                                       loginPassword, @CACHED_NEW_PASSWORD,
                                       nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@AUTO_FILL object:nil userInfo:newUserDictionary];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
