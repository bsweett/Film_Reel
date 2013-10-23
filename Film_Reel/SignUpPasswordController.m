//
//  SignUpPasswordController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "SignUpPasswordController.h"

@interface SignUpPasswordController () <UITextFieldDelegate>

@end

@implementation SignUpPasswordController

@synthesize passField;
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
    passField.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doNextButton:(id)sender
{
    NSString * password = passField.text;
    NSString * errorMessage = @"";
    
    [passField resignFirstResponder];
    
    if(![password  isEqual: @""])
    {
        if( [self validatePasswordWithString:password] == TRUE )
        {
            [self performSegueWithIdentifier:@"finish" sender:sender];
            //Start Network operations method
            // inside that method handle networking errors and check to make sure username is not already used
            // When the networking operations finish return a BOOLEAN Value to push to next step
        } else
        {
            errorMessage = @"Password must be between 8 and 18 characters";
            error = [[UIAlertView alloc] initWithTitle: @"Invalid Password" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
        
    } else
    {
        errorMessage = @"Please fill in the required field";
        error = [[UIAlertView alloc] initWithTitle: @"Password Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
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
