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
@synthesize indicator;
@synthesize userRequest;
@synthesize titlebar;
@synthesize passConfirm;
@synthesize newlyMadeUser;

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
    passConfirm.delegate = self;
    [emailField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passConfirm setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailField setReturnKeyType:UIReturnKeyNext];
    [userField setReturnKeyType:UIReturnKeyNext];
    [passField setReturnKeyType:UIReturnKeyNext];
    [passConfirm setReturnKeyType:UIReturnKeyDone];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_ALREADY_EXISTS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@SIGNUP_SUCCESS object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Runs when login button is pressed
-(IBAction)doNextButton:(id)sender
{
    // Grab values and alloc network object and error Messages
    userRequest = [[Networking alloc] init];
    NSString * email = emailField.text;
    NSString * username = userField.text;
    NSString * password = passField.text;
    NSString * confirmPassword = passConfirm.text;
    NSString * errorTitle = @"Error";
    NSMutableString * errorMessage = [[NSMutableString alloc] init];
    
    // Drop keyboard
    [emailField resignFirstResponder];
    [userField resignFirstResponder];
    [passField resignFirstResponder];
    [passConfirm resignFirstResponder];
    
    
    if(![email  isEqual: @""] && ![username  isEqual: @""] && ![password  isEqual: @""])
    {
        if( [self validateEmailWithString:email] == FALSE )
        {
            [errorMessage appendString: @"Must be a valid email address\n"];
        }
        if ( [self validateUserNameWithString:username] == FALSE )
        {
            [errorMessage appendString: @"Username can only contain letters and numbers (MAX 30)\n"];
        }
        if  ( [self validatePasswordWithString:password withCPass:confirmPassword] == FALSE )
        {
            [errorMessage appendString: @"Password must be between 8 and 18 characters and match in both fields\n"];
        }
        
        // If everything is the correct format
        if([self validateEmailWithString:email] == TRUE && [self validateUserNameWithString:username] == TRUE && [self validatePasswordWithString:password withCPass:confirmPassword] == TRUE)
        {
            titlebar.backBarButtonItem.enabled = NO;
            
            // Build URL
            NSString* request = [self buildSignUpRequest:email withName:username withPassword:password];
            
            // NOTE:: Comment this out to bypass networking
            [userRequest startReceive:request withType:@SIGNUP_REQUEST];
            
            // Set up awesome spiny wheel
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:self.view.frame];
            CGPoint center = self.view.center;
            indicator.center = center;
            [indicator.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
            [self.view addSubview:indicator];

            // Animate it
            if([userRequest isReceiving] == TRUE)
            {
                [indicator startAnimating];
            }

            // NOTE:: If you need to bypass create account uncomment this
            //[self performSegueWithIdentifier:@"done" sender:sender];
            
        } else {
            // Format Errors
            error = [[UIAlertView alloc] initWithTitle: errorTitle message: errorMessage delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
            [error show];
        }
    
    }
    else
    {
        // Empty Field Errors
        error = [[UIAlertView alloc] initWithTitle: @"Input Error" message:@"Please fill in the required fields" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        [error show];
    }
    

}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildSignUpRequest: (NSString*) email withName: (NSString*) name withPassword: (NSString*) password
{
    NSMutableString* signup = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [signup appendString:@"create?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"email=%@" , email];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&name=%@" , name];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&password=%@" , password];
    
    [signup appendString:parameter1];
    [signup appendString:parameter2];
    [signup appendString:parameter3];
    
    NSLog(@"Create Account request:: %@", signup);
    
    return [signup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@ADDRESS_FAIL_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        titlebar.backBarButtonItem.enabled = YES;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@SERVER_CONNECT_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        titlebar.backBarButtonItem.enabled = YES;
    }
}

// Dismiss dialogs when done
-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// Handles Succussful acount creation
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@SIGNUP_SUCCESS])
    {
        [indicator stopAnimating];
        NSDictionary* userDictionary = [notif userInfo];
        newlyMadeUser = [userDictionary valueForKey:@CURRENT_USER];
        [self performSegueWithIdentifier:@"done" sender:self];
    }
    
    if([[notif name] isEqualToString:@USER_ALREADY_EXISTS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:@"User Already Exists" message:@"Email and/or Username is already used" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [error show];
    }
}

// Pass token object to complete controller
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"done"])
    {
        
        SignUpCompleteController* destViewController = segue.destinationViewController;
        destViewController.createdUser = newlyMadeUser;
    }
}

// Drops keyboard when return key is pressed
- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
    /*
    if(textField )
    [textField resignFirstResponder];
    return YES;*/
}

// Validations for Email, Passoword, and Username ------------------------------------------
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

- (BOOL)validatePasswordWithString:(NSString *)pass withCPass:(NSString *)cpass
{
    if(![pass isEqualToString:cpass])
    {
        NSLog(@"Passwords didnt match");
        return FALSE;
    }
    if( pass.length >= MIN_PASS_ENTRY && pass.length <= MAX_PASSWORD_ENTRY )
    {
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§%&/()@]+";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    }
    
    return FALSE;
}
// --------------------------------------------------------------------------------------

@end
