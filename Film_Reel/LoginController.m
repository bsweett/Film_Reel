//
//  ViewController.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class controls the main login view. It handles the request building for logging a user in
//  and does local validation on text that is entered for username and password. It gets
//  notifications from the Networking Class and updates its view accordingly.
//

#import "LoginController.h"

@interface LoginController () <UITextFieldDelegate>
@end


@implementation LoginController

@synthesize usernameField;
@synthesize passwordField;
@synthesize error;
@synthesize loginrequest;
@synthesize indicator;
@synthesize loginButton;
@synthesize createButton;
@synthesize currentUser;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * This method is called when the Login Controller is loaded for the first
 * time. It sets delegates and disables autocorrection. Also hides nav bar
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    usernameField.delegate           = self;
    passwordField.delegate           = self;
    usernameField.keyboardAppearance = UIKeyboardAppearanceDark;
    passwordField.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [loginButton setEnabled:TRUE];
    [createButton setEnabled:TRUE];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden: YES animated:NO];
}


/**
 * This method is called when the Login Controller appears as the view
 * Adds Obeservers for auto filling after signup and network operations
 *
 * @param animated A BOOL sent from the view that called the transtion
 */
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden: YES animated:NO];
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
                                                name:@USER_NOT_FOUND
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@LOGIN_SUCCESS
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(shouldAutoFillFields:)
                                                name:@AUTO_FILL
                                              object:nil];
}


/**
 * Handles any memory warnings sent from the OS
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles login button pressed by user. Grabs strings from feilds and checks
 * to make sure theu arent empty and are valid for our username and password.
 * Starts an indicator and sends the network request to login. Display alerts 
 * for an string issues before sending
 *
 * @param sender The sender is this view controller
 */
-(IBAction)doLoginButton:(id)sender
{
    loginrequest            = [[Networking alloc] init];
    NSString * username     = usernameField.text;
    NSString * password     = passwordField.text;
    NSString * errorMessage = @"";

    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    // Validate username and password otherwise display an error dialog
    if(![username  isEqual: @""] && ![password  isEqual: @""])
    {
        if([self validateUserNameWithString:username] == TRUE &&
           [self validatePasswordWithString:password] == TRUE)
        {
            loginButton.enabled = NO;
            createButton.enabled = NO;
            
            // Build login request and open connection
            NSString* requestURL = [self buildLoginRequest:username withPassword:password];
            [loginrequest startReceive:requestURL withType:@LOGIN_REQUEST];
            
            // Set up the indicator on the view
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                                                        UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:self.view.frame];
            CGPoint center = self.view.center;
            indicator.center = center;
            [indicator.layer setBackgroundColor:[[UIColor colorWithWhite:0.0
                                                                   alpha:0.30] CGColor]];
            [self.view addSubview:indicator];
            
            // If request isReceiving start spinning
            if([loginrequest isReceiving] == TRUE)
            {
                [indicator startAnimating];
            }
        }
        else
        {
            errorMessage = @"Password or Username are the wrong length or contain invalid characters";
            error = [[UIAlertView alloc] initWithTitle: @"Login Error"
                                               message: errorMessage
                                              delegate: self
                                     cancelButtonTitle: @"Ok"
                                     otherButtonTitles: nil];
            [error show];
        }
    }
    else
    {
        errorMessage = @"Please fill in the required fields";
        error = [[UIAlertView alloc] initWithTitle: @"Login Error"
                                           message: errorMessage
                                          delegate: self
                                 cancelButtonTitle: @"Ok"
                                 otherButtonTitles: nil];
        [error show];
    }
    
    
}


/**
 * Unused action for opening a create account view. Segue is called
 * via storyboard and nothing is being passed ATM
 *
 * @param sender The sender is this view controller
 */
-(IBAction)doCreateButton:(id)sender {}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Networking Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * This function is a request Builder for login in. It builds and formats a string for
 * use in the Networking class.
 *
 * @param name The username that is trying to login
 * @param password The password that is trying to login
 * @return login A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildLoginRequest: (NSString*) name withPassword: (NSString*) password
{
    NSMutableString* login = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [login appendString:@"login?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"id=%@" , name];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&password=%@" , password];
    
    [login appendString:parameter1];
    [login appendString:parameter2];
    
    NSLog(@"REQUEST INFO:: Login -- %@", login);
    
    return [login stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


/**
 * Handles any general networking errors from a Network Operation
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil
                                           message:@ADDRESS_FAIL_ERROR
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [error show];
        
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        createButton.enabled = YES;
        loginButton.enabled  = YES;
    }
    
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil
                                           message:@SERVER_CONNECT_ERROR
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [error show];
        
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        createButton.enabled = YES;
        loginButton.enabled  = YES;
    }
}


/**
 * Simple method of dimissing all alerts without buttons
 *
 * @param alert The alert is passed by the alertView we wish to dismiss
 */
-(void) dismissErrors:(UIAlertView*) alert { [alert dismissWithClickedButtonIndex:0 animated:YES]; }


/**
 * Handles a response from the Server. If its a success it logs the user
 * in and stores all of thier values in NSUserDefaults. If the users 
 * login was delcined by the server display a dialog
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@LOGIN_SUCCESS])
    {
        currentUser = [[notif userInfo] valueForKey:@CURRENT_USER];
        
        AppDelegate* shared = [AppDelegate appDelegate];
        
        //Set App User in our App Delegate
        [shared setAppUser: currentUser];
        
        // Store defaults here so token wont be null on first backgrounding
        NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
        if([currentUser getToken] != nil)
        {
            NSLog(@"TOKEN INFO:: Token stored at login %@", currentUser.token);
            
            NSString* storeToken              = currentUser.token;
            NSString* storeName               = currentUser.userName;
            NSString* storeBio                = currentUser.userBio;
            NSString* storeLoc                = currentUser.location;
            NSString* storePass               = currentUser.password;
            NSString* storeEmail              = currentUser.email;
            NSString* storePop                = currentUser.popularity;
            NSString* storeGender             = currentUser.gender;
            NSMutableDictionary* storeFriends = currentUser.getFriendList;
            
            [currentLoggedIn setObject:storeToken   forKey:@CURRENT_USER_TOKEN];
            [currentLoggedIn setObject:storeName    forKey:@CURRENT_USER_NAME];
            [currentLoggedIn setObject:storePass    forKey:@CURRENT_USER_PASSWORD];
            [currentLoggedIn setObject:storeLoc     forKey:@CURRENT_USER_LOCATION];
            [currentLoggedIn setObject:storeEmail   forKey:@CURRENT_USER_EMAIL];
            [currentLoggedIn setObject:storeBio     forKey:@CURRENT_USER_BIO];
            [currentLoggedIn setObject:storePop     forKey:@CURRENT_USER_POP];
            [currentLoggedIn setObject:storeGender  forKey:@CURRENT_USER_GENDER];
            [currentLoggedIn setObject:storeFriends forKey:@CURRENT_USER_FRIENDS];
            [currentLoggedIn synchronize];
        }
        
        [indicator stopAnimating];
        [self performSegueWithIdentifier:@"loggedIn" sender:self];
    }
    
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil
                                           message:@"Username or password incorrect"
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [error show];
        
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        loginButton.enabled  = YES;
        createButton.enabled = YES;
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Textfield and Validation Functions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * If the user has come from the a successful create account view a
 * notification is sent with them containing thier login info.
 *
 * @param notif The Notification that was sent from SignUpCompleteController
 */
- (void) shouldAutoFillFields: (NSNotification*) notif
{
    NSDictionary* newUserDictionary = [notif userInfo];
    NSString* fillUser              = [newUserDictionary valueForKey:@CACHED_NEW_USER];
    NSString* fillPass              = [newUserDictionary valueForKey:@CACHED_NEW_PASSWORD];
    
    [[self usernameField] setText:fillUser];
    [[self passwordField] setText:fillPass];
}


/**
 * Handles dropping the keyboard when the enter key is pressed.
 *
 * @param textfield UITextField who is using the keyboard
 * @return YES always returns YES BOOL
 */
- (BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    return YES;
}


/**
 * This method checks a username string to make sure its not too long or 
 * short and to make sure it doesnt contain anything but letters (both caps 
 * and not) and numbers.
 *
 * @param username A username string to check
 * @return BOOL false is the username doesnt match true if it does
 */
- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length >= MIN_ENTRY_SIZE && username.length <= MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex   = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    }
    else
    {
        return FALSE;
    }
}


/**
 * This method checks a password string to make sure its not too long or
 * short and to make sure it doesnt contain anything but letters (both caps
 * and not), numbers, and special characters.
 *
 * @param password A password string to check
 * @return BOOL false is the password doesnt match true if it does
 */
- (BOOL)validatePasswordWithString:(NSString*)pass
{
    if( pass.length >= MIN_PASS_ENTRY && pass.length <= MAX_PASSWORD_ENTRY )
    {
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§%&/()@]+";
        NSPredicate *emailTest  = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    }
    else
    {
        return FALSE;
    }
}

@end
