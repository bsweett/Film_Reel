//
//  SignUpCompleteController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "SignUpCompleteController.h"

@interface SignUpCompleteController ()

@end

@implementation SignUpCompleteController

@synthesize createdUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// When login is press set the token
// Until then they are not logged in
-(IBAction) doLogIn:(id) sender
{
    AppDelegate* shared = [AppDelegate appDelegate];
    shared.token = createdUser.getToken;
    NSLog(@"INFO:: Token on Log in: %@", shared.token);
}

@end
