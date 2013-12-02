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

@synthesize loginPassword;
@synthesize loginUsername;

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

// When login is press send them back to the login page
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
