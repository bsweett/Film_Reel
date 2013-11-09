//
//  SignUpEmailController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "SignUpEmailController.h"

@interface SignUpEmailController () <UITextFieldDelegate>

@end

@implementation SignUpEmailController

@synthesize emailField;
@synthesize userField;
@synthesize passField;
@synthesize error;
@synthesize loading;
@synthesize userRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    emailField.delegate = self;
    userField.delegate = self;
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
    
    NSString * email = emailField.text;
    NSString * username = userField.text;
    NSString * password = passField.text;
    NSString * errorTitle = @"Error";
    NSMutableString * errorMessage = [[NSMutableString alloc] init];
    
    [emailField resignFirstResponder];
    [userField resignFirstResponder];
    [passField resignFirstResponder];
    
    if(![email  isEqual: @""] && ![username  isEqual: @""] && ![password  isEqual: @""])
    {
        if( [self validateEmailWithString:email] == FALSE )
        {
            [errorMessage appendString: @"Must be a valid email address\n"];
        }
        if ( [self validateUserNameWithString:username] == FALSE )
        {
            [errorMessage appendString: @"Username can only have letters and numbers and must between 4-30 characters\n"];
        }
        if  ( [self validatePasswordWithString:username] == FALSE )
        {
            [errorMessage appendString: @"Password must be between 8 and 18 characters\n"];
        }
        
        if([self validateEmailWithString:email] == TRUE && [self validateUserNameWithString:username] == TRUE && [self validatePasswordWithString:username] == TRUE)
        {
            [userRequest startReceive:@"http"];
            //Start Network operations method
            // inside that method handle networking errors and check to make sure email is not already used
            // When the networking operations finish return a BOOLEAN Value to push to next step
            
            if([userRequest isReceiving] == TRUE)
            {
                loading = [[UIAlertView alloc] initWithTitle: @"Receiving..." message:nil delegate: self cancelButtonTitle:nil otherButtonTitles: nil];
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                
                // Adjust the indicator so it is up a few pixels from the bottom of the alert
                indicator.center = CGPointMake(loading.bounds.size.width / 2, loading.bounds.size.height - 50);
                [indicator startAnimating];
                [loading addSubview:indicator];
                [loading show];
            }
            
            if([userRequest isReceiving] == FALSE)
            {
                [loading dismissWithClickedButtonIndex:0 animated:YES];
            }
            
            // if network stops without error
             [self performSegueWithIdentifier:@"done" sender:sender];
            
        } else {
            error = [[UIAlertView alloc] initWithTitle: errorTitle message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
    
    }
    else
    {
        error = [[UIAlertView alloc] initWithTitle: @"Input Error" message:@"Please fill in the required fields" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
    

}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

// Validations --------------------------------------------------------------------
- (BOOL)validateEmailWithString:(NSString*)emailaddress
{
    if(emailaddress.length >= MIN_EMAIL_ENTRY && emailaddress.length <= MAX_EMAIL_ENTRY)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:emailaddress];
    }
    
    return FALSE;
}

- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length >= MIN_ENTRY_SIZE && username.length <= MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    }
    
    return FALSE;
}

- (BOOL)validatePasswordWithString:(NSString*)pass
{
    if( pass.length >= MIN_PASS_ENTRY && pass.length <= MAX_PASSWORD_ENTRY )
    {
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    }
    
    return FALSE;
}

@end
