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
    emailField.delegate = self;
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
    NSString * errorMessage = @"";
    
    [emailField resignFirstResponder];
    
    if(![email  isEqual: @""])
    {
        if( [self validateEmailWithString:email] == TRUE )
        {
            [self performSegueWithIdentifier:@"password" sender:sender];
            //Start Network operations method
            // inside that method handle networking errors and check to make sure email is not already used
            // When the networking operations finish return a BOOLEAN Value to push to next step
        } else
        {
            errorMessage = @"Not a valid Email Address";
            error = [[UIAlertView alloc] initWithTitle: @"Email Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
   
    } else
    {
        errorMessage = @"Please fill in the required field";
        error = [[UIAlertView alloc] initWithTitle: @"Email Error" message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validateEmailWithString:(NSString*)emailaddress
{
    if(emailaddress.length > MIN_EMAIL_ENTRY && emailaddress.length < MAX_EMAIL_ENTRY)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:emailaddress];
    } else
    {
        return FALSE;
    }
}

@end
