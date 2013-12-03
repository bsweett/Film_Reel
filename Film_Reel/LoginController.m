//
//  ViewController.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    usernameField.delegate = self;
    passwordField.delegate = self;
    [usernameField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [passwordField setAutocorrectionType:UITextAutocorrectionTypeNo];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden: YES animated:YES];
    // NOTE:: Should have another notification that tells user if the information they entered doesnt exist (no password or username matching)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_NOT_FOUND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shouldAutoFillFields:) name:@AUTO_FILL object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doLoginButton:(id)sender
{
    loginrequest = [[Networking alloc] init];
    NSString * username = usernameField.text;
    NSString * password = passwordField.text;
    NSString * errorMessage = @"";

    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    
    if(![username  isEqual: @""] && ![password  isEqual: @""])
    {
        if([self validateUserNameWithString:username] == TRUE && [self validatePasswordWithString:password] == TRUE)
        {
            loginButton.enabled = NO;
            createButton.enabled = NO;
            
            NSString* requestURL = [self buildLoginRequest:username withPassword:password];
    
            // NOTE:: to bypass login comment out
            [loginrequest startReceive:requestURL withType:@LOGIN_REQUEST];
            
            // Set up awesome spiny wheel
            indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [indicator setFrame:self.view.frame];
            CGPoint center = self.view.center;
            indicator.center = center;
            [indicator.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
            [self.view addSubview:indicator];
            
            // Animate it
            if([loginrequest isReceiving] == TRUE)
            {
                [indicator startAnimating];
            }
            
            // NOTE:: to bypass login uncomment
            //[self performSegueWithIdentifier:@"loggedIn" sender:sender];
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

// Empty Action for Create Account?
-(IBAction)doCreateButton:(id)sender{}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
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

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@ADDRESS_FAIL_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        createButton.enabled = YES;
        loginButton.enabled = YES;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@SERVER_CONNECT_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        createButton.enabled = YES;
        loginButton.enabled = YES;
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
    if([[notif name] isEqualToString:@LOGIN_SUCCESS])
    {
        NSDictionary* userDictionary = [notif userInfo];
        currentUser = [userDictionary valueForKey:@CURRENT_USER];
        
        AppDelegate* shared = [AppDelegate appDelegate];
        
        //Set App User
        [shared setAppUser: currentUser];
        
        NSLog(@"INFO:: Current User Token:: %@", [currentUser getToken]);
        [indicator stopAnimating];
        [self performSegueWithIdentifier:@"loggedIn" sender:self];
    }
    
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@"Username or password incorrect" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        loginButton.enabled = YES;
        createButton.enabled = YES;
    }
}

- (void) shouldAutoFillFields: (NSNotification*) notif
{
    NSDictionary* newUserDictionary = [notif userInfo];
    NSString* fillUser = [newUserDictionary valueForKey:@CACHED_NEW_USER];
    NSString* fillPass = [newUserDictionary valueForKey:@CACHED_NEW_PASSWORD];
    
    [[self usernameField] setText:fillUser];
    [[self passwordField] setText:fillPass];
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
        NSString *passwordRegex = @"^[a-zA-Z_0-9\\-_,;.:#+*?=!§%&/()@]+";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
        return [emailTest evaluateWithObject:pass];
    } else
    {
        return FALSE;
    }
}
// -------------------------------------------------------------------------------


@end
