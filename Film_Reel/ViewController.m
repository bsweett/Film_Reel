//
//  ViewController.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "ViewController.h"


@interface ViewController () <UITextFieldDelegate>

@end


@implementation ViewController

@synthesize usernameField;
@synthesize passwordField;
@synthesize error;

- (void)viewDidLoad
{
    [super viewDidLoad];
    usernameField.delegate = self;
    passwordField.delegate = self;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doLoginButton:(id)sender
{
    NSString * username = usernameField.text;
    NSString * password = passwordField.text;
    NSString * errorMessage = @"";

    
    if(![username  isEqual: @""] && ![password  isEqual: @""])
    {
        if([self validateUserNameWithString:username] == TRUE && [self validatePasswordWithString:password] == TRUE)
        {
            [self performSegueWithIdentifier:@"loggedIn" sender:sender];
                //Start Network operations method
                // inside that method handle networking errors and invavlid user and password errors
                // When the networking operations finish return a BOOLEAN Value to start the modal to main app view
        } else
        {
            errorMessage = @"Password or Username are the wrong length or contain invalid characters";
            error = [[UIAlertView alloc] initWithTitle: @"Login Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
    } else
    {
        errorMessage = @"Please fill in the required fields";
        error = [[UIAlertView alloc] initWithTitle: @"Login Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
    
    
}

-(IBAction)doCreateButton:(id)sender
{
    
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}


// Validations --------------------------------------------------------------------
- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length >= MIN_ENTRY_SIZE && username.length <= MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    } else
    {
        return FALSE;
    }
}

- (BOOL)validatePasswordWithString:(NSString*)pass
{
    if( pass.length >= MIN_PASS_ENTRY && pass.length <= MAX_PASSWORD_ENTRY )
    {
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    } else
    {
        return FALSE;
    }
}


@end
