//
//  SignUpUsernameController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "SignUpUsernameController.h"

@interface SignUpUsernameController () <UITextFieldDelegate>

@end

@implementation SignUpUsernameController

@synthesize userField;
@synthesize error;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)doNextButton:(id)sender
{
    NSString * user = userField.text;
    NSString * errorMessage = @"";
    
    [userField resignFirstResponder];
    
    if(![user  isEqual: @""])
    {
        if( [self validateUserNameWithString:user] == TRUE )
        {
            [self performSegueWithIdentifier:@"password" sender:sender];
            //Start Network operations method
            // inside that method handle networking errors and check to make sure username is not already used
            // When the networking operations finish return a BOOLEAN Value to push to next step
        } else
        {
            errorMessage = @"Username can only have letters and numbers and must between 4-30 characters";
            error = [[UIAlertView alloc] initWithTitle: @"Invalid Username" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
        
    } else
    {
        errorMessage = @"Please fill in the required field";
        error = [[UIAlertView alloc] initWithTitle: @"Username Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

// Validations --------------------------------------------------------------------
- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length > MIN_ENTRY_SIZE && username.length < MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    } else
    {
        return FALSE;
    }
}

@end
