//
//  AppDelegate.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Main control point for application
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize startingview;
@synthesize bypassLogin;
@synthesize appUser;
@synthesize validToken;
@synthesize main;
@synthesize isTokenValid;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Utility Functions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/** These methods are used to return the current app user object
 * and create and instance of the app delegate to use else where.
 *
 */
//---------------------------------------------------------------------
+(AppDelegate *) appDelegate
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}

-(User*) getAppUser
{
    return appUser;
}

-(void) setAppUser: (User*) aUser
{
    appUser = aUser;
}
//---------------------------------------------------------------------

/**
 * RGB color converter from a given hex string
 *
 * @param hex A string that is a hex color code
 */
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Application Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Customize app after launch. Log the device running the app.
 *
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LogInfo(@"Finished Launching on Device model: %@", [UIDevice currentDevice].model);
    [[UINavigationBar appearance] setBarTintColor:[self colorWithHexString:@BAR_COLOR]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    return YES;
}


/**
 * Log Transition into background
 *
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"==============================================================================");
    NSLog(@"====                             Background                               ====");
    NSLog(@"==============================================================================");
}


/**
 * Store User defaults
 *
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    
    if([appUser getDP] == nil) {
        LogDebug(@"Null in here? ");
    }
 
    LogInfo(@"TOKEN:: Token into background %@", appUser.token);

    NSString* storeToken              = appUser.token;
    NSString* storeName               = appUser.userName;
    NSString* storeBio                = appUser.userBio;
    NSString* storeLoc                = appUser.location;
    NSString* storePass               = appUser.password;
    NSString* storeEmail              = appUser.email;
    NSString* storePop                = appUser.popularity;
    NSString* storeGender             = appUser.gender;
    NSMutableDictionary* storeFriends = appUser.getFriendList;
    NSData  * storeImage              = UIImageJPEGRepresentation(appUser.getDP, 0.1f);
    NSString* storeImagePath          = appUser.getDisplayPicturePath;
    
    [currentLoggedIn setObject:storeToken forKey:@CURRENT_USER_TOKEN];
    [currentLoggedIn setObject:storeName forKey:@CURRENT_USER_NAME];
    [currentLoggedIn setObject:storePass forKey:@CURRENT_USER_PASSWORD];
    [currentLoggedIn setObject:storeLoc forKey:@CURRENT_USER_LOCATION];
    [currentLoggedIn setObject:storeEmail forKey:@CURRENT_USER_EMAIL];
    [currentLoggedIn setObject:storeBio forKey:@CURRENT_USER_BIO];
    [currentLoggedIn setObject:storePop forKey:@CURRENT_USER_POP];
    [currentLoggedIn setObject:storeGender forKey:@CURRENT_USER_GENDER];
    [currentLoggedIn setObject:storeFriends forKey:@CURRENT_USER_FRIENDS];
    [currentLoggedIn setObject:storeImage forKey:@CURRENT_USER_IMAGE];
    [currentLoggedIn setObject:storeImagePath forKey:@CURRENT_USER_IMAGE_PATH];
    [currentLoggedIn synchronize];
}


// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
- (void)applicationWillEnterForeground:(UIApplication *)application {}


/**
 * Grab the user values from storage on resume and start a token request
 *
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    appUser = [[User alloc] init];
    
    // Check which storybaord to load
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        main = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
    }
    else
    {
        main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    // Add our notifications observers
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ERROR_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@VALID_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@INVALID_TOKEN  object:nil];
    
    // Get our user defaults
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    appUser.token                   = [currentLoggedIn objectForKey:@CURRENT_USER_TOKEN];
    appUser.userName                = [currentLoggedIn objectForKey:@CURRENT_USER_NAME];
    appUser.gender                  = [currentLoggedIn objectForKey:@CURRENT_USER_GENDER];
    appUser.popularity              = [currentLoggedIn objectForKey:@CURRENT_USER_POP];
    appUser.location                = [currentLoggedIn objectForKey:@CURRENT_USER_LOCATION];
    appUser.email                   = [currentLoggedIn objectForKey:@CURRENT_USER_EMAIL];
    appUser.userBio                 = [currentLoggedIn objectForKey:@CURRENT_USER_BIO];
    appUser.friendsList             = [currentLoggedIn objectForKey:@CURRENT_USER_FRIENDS];
    appUser.displayPicturePath      = [currentLoggedIn objectForKey:@CURRENT_USER_IMAGE_PATH];
    appUser.displayPicture          = [UIImage imageWithData:[currentLoggedIn objectForKey:@CURRENT_USER_IMAGE]];
    
    NSString* token                 = [appUser getToken];

    if(token != nil)
    {
        isTokenValid = @"?";
        validToken = [[Networking alloc] init];
        LogInfo(@"TOKEN:: Token after background %@", token);
        NSString* request = [self buildTokenLoginRequest:token];
        [validToken startReceive:request withType:@VALID_REQUEST];
        
        // Might need to tweak this section if networking is slow (Black page?)
        if([validToken isReceiving])
        {
            UIView *view   = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            UIImage* image = [UIImage imageNamed:@"LaunchImage-700-Portrait"];
            [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
    }
    else
    {
        // Token is null and hasnt been set
        // Send them to login screen to get another token
        LogInfo(@"TOKEN:: Token was returned NULL from the NSUSERDEFAULTS\n");
        startingview = [main instantiateInitialViewController];
        self.window.rootViewController = startingview;
    }
}

// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
- (void)applicationWillTerminate:(UIApplication *)application {}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Networking Handlers and Builder
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * This function is a request Builder for token checking. It builds and
 * formats a string for use in the Networking class.
 *
 * @param tokenToCHeck token from storage
 * @return friendData A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildTokenLoginRequest: (NSString*) tokenToCheck
{
    NSMutableString* valid = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [valid appendString:@"tokenlogin?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , tokenToCheck];
    
    [valid appendString:parameter1];
    
    LogInfo(@"TOKEN:: TokenLogin request:: %@", valid);
    
    return valid;
}


/**
 * Handles any general networking errors from a Network Operation
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didGetNetworkError: (NSNotification*) notif
{
    startingview = [main instantiateInitialViewController];
    if([[notif name] isEqualToString:@ERROR_STATUS])
    {
        LogError(@"Server threw an exception");
        self.window.rootViewController = startingview;
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        LogError(@"Request Address was not URL formatted");
        self.window.rootViewController = startingview;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        self.window.rootViewController = startingview;
    }
}


/**
 * If valid token is returned from server bypass login page. 
 * Otherwise send them to login to get a new one
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@VALID_SUCCESS])
    {
        appUser = [[notif userInfo] valueForKey:@CURRENT_USER];
        bypassLogin= [main instantiateViewControllerWithIdentifier:@"bypass"];
        self.window.rootViewController = bypassLogin;
        LogInfo(@"TOKEN:: Token has been confirmed by server - ALLOW BYPASS\n");
    }
    
    if([[notif name] isEqualToString:@INVALID_TOKEN])
    {
        startingview = [main instantiateInitialViewController];
        self.window.rootViewController = startingview;
        LogInfo(@"TOKEN INFO:: Token has been devalidate by server\n");
    }
}


@end
