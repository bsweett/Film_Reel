//
//  SignUpEmailController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Handles proper account creation. Sends data to server to check if the user exists or not.
//
//  TODO:: let them optional fill in gender, location etc..
//

#import "SignUpController.h"

@interface SignUpController () <UITextFieldDelegate>

@end

@implementation SignUpController

@synthesize emailField;
@synthesize userField;
@synthesize passField;
@synthesize error;
@synthesize indicator;
@synthesize userRequest;
@synthesize titlebar;
@synthesize passConfirm;
@synthesize newlyMadeUser;

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
 * This method is called when the SignUpController is loaded for the first
 * time. It adds some observers for networking notifications sets up the 
 * textfields
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    emailField.delegate  = self;
    userField.delegate   = self;
    passField.delegate   = self;
    passConfirm.delegate = self;
    [emailField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [userField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passConfirm setAutocorrectionType:UITextAutocorrectionTypeNo];
    [emailField setReturnKeyType:UIReturnKeyNext];
    [userField setReturnKeyType:UIReturnKeyNext];
    [passField setReturnKeyType:UIReturnKeyNext];
    [passConfirm setReturnKeyType:UIReturnKeyDone];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didGetNetworkError:)
                                                name:@ERROR_STATUS
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didGetNetworkError:)
                                                name:@ADDRESS_FAIL
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didGetNetworkError:)
                                                name:@FAIL_STATUS
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@USER_ALREADY_EXISTS
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@SIGNUP_SUCCESS
                                              object:nil];
}


/**
 * This method is called when the SignupController appears as the view.
 * It sets the nav bar to appear
 *
 * @param animated A BOOL sent from the view that called the transtion
 */
- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden: NO animated:YES];
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


/**
 * When the "sender" segaue is called this method will pass the username and
 * passsword over to the complete page
 *
 * @param segue The segue the will make the view change
 * @param sender This segue will be called from this view controller (self)
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SignUpCompleteController* destViewContorller = segue.destinationViewController;
    destViewContorller.loginUsername             = userField.text;
    destViewContorller.loginPassword             = passField.text;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Create Account Action
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Checks to make sure all feilds are filled in when the next button is pushed.
 * Then it will send the request to create the user and update the UI.
 *
 * @param sender This segue will be called from this view controller (self)
 */
-(IBAction)doNextButton:(id)sender
{
    // Grab values and alloc network object and error Messages
    userRequest                    = [[Networking alloc] init];
    NSString * email               = emailField.text;
    NSString * username            = userField.text;
    NSString * password            = passField.text;
    NSString * confirmPassword     = passConfirm.text;
    NSString * errorTitle          = @"Error";
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
        if([self validateEmailWithString:email] == TRUE && [self validateUserNameWithString:username] == TRUE &&
           [self validatePasswordWithString:password withCPass:confirmPassword] == TRUE)
        {
            titlebar.backBarButtonItem.enabled = NO;
            
            // Build URL
            NSString* request = [self buildSignUpRequest:email withName:username withPassword:password];
            [userRequest startReceive:request withType:@SIGNUP_REQUEST];
            
            // set up indicator
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:self.view.frame];
            CGPoint center = self.view.center;
            indicator.center = center;
            [indicator.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
            [self.view addSubview:indicator];

            // Animate it
            if([userRequest isReceiving] == TRUE)
            {
                self.navigationController.navigationBar.userInteractionEnabled=NO;
                [indicator startAnimating];
            }
        }
        else {
            // Format Errors
            error = [[UIAlertView alloc] initWithTitle: errorTitle message: errorMessage
                                              delegate: self
                                     cancelButtonTitle: @"Ok"
                                     otherButtonTitles: nil];
            [error show];
        }
    
    }
    else
    {
        // Empty Field Errors
        error = [[UIAlertView alloc] initWithTitle: @"Input Error"
                                           message:@"Please fill in the required fields"
                                          delegate: self
                                 cancelButtonTitle: @"Ok"
                                 otherButtonTitles: nil];
        [error show];
    }
    

}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Network Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles any general networking errors from a Network Operation
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ERROR_STATUS])
    {
        LogError(@"Server threw an exception");
        [indicator stopAnimating];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        LogError(@"Request Address was not URL formatted");
        [indicator stopAnimating];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@SERVER_CONNECT_ERROR
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
}


/**
 * Simple method of dimissing all alerts without buttons
 *
 * @param alert The alert is passed by the alertView we wish to dismiss
 */
-(void) dismissErrors:(UIAlertView*) alert { [alert dismissWithClickedButtonIndex:0 animated:YES]; }


/**
 * If account is created correctly preform segue. Otherwise user
 * already exists.
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@SIGNUP_SUCCESS])
    {
        [indicator stopAnimating];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
        [self performSegueWithIdentifier:@"done" sender:self];
    }
    
    if([[notif name] isEqualToString:@USER_ALREADY_EXISTS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:@"User Already Exists"
                                           message:@"Email and/or Username is already used"
                                          delegate:self
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [error show];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark String builders and validation
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Drops textfeild when on last feild. Enter button is turned to next
 * to move through the feilds from top down
 *
 * @param textfeild The Textfeild in use
 */
- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    NSInteger nextTag          = textField.tag + 1;
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [nextResponder becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return NO;
}


/**
 * This function is a request Builder for creating a new user. It builds and 
 * formats a string for use in the Networking class.
 *
 * @param email email of a new user
 * @param name  name of new user
 * @param password password of new user
 * @return signup A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildSignUpRequest: (NSString*) email withName: (NSString*) name withPassword: (NSString*) password
{
    NSMutableString* signup = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [signup appendString:@"create?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"name=%@" , name];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&password=%@" , password];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&email=%@" , email];
    
    [signup appendString:parameter1];
    [signup appendString:parameter2];
    [signup appendString:parameter3];
    
    LogInfo(@"REQUEST:: Create Account --  %@", signup);
    
    return [signup stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


/**
 * This function checks to make sure the email entered is an actual email address
 *
 * @param emailAddress email to check
 * @return BOOL True if its a valid email, false if not
 */
- (BOOL)validateEmailWithString:(NSString*)emailaddress
{
    if(emailaddress.length >= MIN_EMAIL_ENTRY && emailaddress.length <= MAX_EMAIL_ENTRY)
    {
        NSString *emailRegex   = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:emailaddress];
    }
    
    return FALSE;
}


/**
 * This function checks to make sure the name entered is a proper name
 *
 * @param name username to check
 * @return BOOL True if its a valid name, false if not
 */
- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length >= MIN_ENTRY_SIZE && username.length <= MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex   = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    }
    
    return FALSE;
}


/**
 * This function checks to make sure the password entered is a proper password
 *
 * @param password password to check
 * @return BOOL True if its a valid password, false if not
 */
- (BOOL)validatePasswordWithString:(NSString *)pass withCPass:(NSString *)cpass
{
    if(![pass isEqualToString:cpass])
    {
        return FALSE;
    }
    if( pass.length >= MIN_PASS_ENTRY && pass.length <= MAX_PASSWORD_ENTRY )
    {
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§%&/()@]+";
        NSPredicate *emailTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    }
    
    return FALSE;
}

@end
