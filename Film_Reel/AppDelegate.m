//
//  AppDelegate.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;
@synthesize startingview;
@synthesize bypassLogin;
@synthesize appUser;
@synthesize validToken;
@synthesize main;

// Call this method anytime we need to get the app delegate
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

// Override point for customization after application launch.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[[UINavigationBar appearance] setTintColor:[[UIColor alloc] initWithRed:0 green:154 blue:255 alpha:1]];
    //[[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"backbutton.png"]];
    //[[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"backbutton.png"]];
    return YES;
}

// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Clear the console
    for(int i = 0; i < 10; i++)
    {
        NSLog(@" ");
    }
}

// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    if(appUser.token != nil)
    {
        NSLog(@"TOKEN INFO:: Token into background %@", appUser.token);
        
        NSString* storeToken = appUser.token;
        NSString* storeName = appUser.userName;
        NSString* storeBio = appUser.userBio;
        NSString* storeLoc = appUser.location;
        NSString* storePass = appUser.password;
        NSString* storeEmail = appUser.email;
        NSString* storePop = appUser.popularity;
        NSString* storeGender = appUser.gender;
        NSMutableDictionary* storeFriends = appUser.getFriendList;
        
        [currentLoggedIn setObject:storeToken forKey:@CURRENT_USER_TOKEN];
        [currentLoggedIn setObject:storeName forKey:@CURRENT_USER_NAME];
        [currentLoggedIn setObject:storePass forKey:@CURRENT_USER_PASSWORD];
        [currentLoggedIn setObject:storeLoc forKey:@CURRENT_USER_LOCATION];
        [currentLoggedIn setObject:storeEmail forKey:@CURRENT_USER_EMAIL];
        [currentLoggedIn setObject:storeBio forKey:@CURRENT_USER_BIO];
        [currentLoggedIn setObject:storePop forKey:@CURRENT_USER_POP];
        [currentLoggedIn setObject:storeGender forKey:@CURRENT_USER_GENDER];
        [currentLoggedIn setObject:storeFriends forKey:@CURRENT_USER_FRIENDS];
        [currentLoggedIn synchronize];
    }
}

// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
- (void)applicationWillEnterForeground:(UIApplication *)application {}

// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
    
    startingview = [main instantiateInitialViewController];
    self.window.rootViewController = startingview;
    
    // Add our notifications observers
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@VALID_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@INVALID_TOKEN  object:nil];
    
    // Get our user defaults
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    appUser.token = [currentLoggedIn objectForKey:@CURRENT_USER_TOKEN];
    appUser.userName = [currentLoggedIn objectForKey:@CURRENT_USER_NAME];
    appUser.gender = [currentLoggedIn objectForKey:@CURRENT_USER_GENDER];
    appUser.popularity = [currentLoggedIn objectForKey:@CURRENT_USER_POP];
    appUser.location = [currentLoggedIn objectForKey:@CURRENT_USER_LOCATION];
    appUser.email = [currentLoggedIn objectForKey:@CURRENT_USER_EMAIL];
    appUser.userBio = [currentLoggedIn objectForKey:@CURRENT_USER_BIO];
    appUser.friendsList = [currentLoggedIn objectForKey:@CURRENT_USER_FRIENDS];
    
    NSString* token = [appUser getToken];
    
    // Start our request
    if(token != nil)
    {
        validToken = [[Networking alloc] init];
        NSLog(@"TOKEN INFO:: Token after background %@", token);
        NSString* request = [self buildTokenLoginRequest:token];
        [validToken startReceive:request withType:@VALID_REQUEST];
        
        // Might need to tweak this section if networking is slow (Black page?)
        if([validToken isReceiving])
        {
            UIView *view=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
            UIImage* image = [UIImage imageNamed:@"LaunchImage-700-Portrait"];
            [view setBackgroundColor:[UIColor colorWithPatternImage:image]];
        }
    }
    else
    {
        // Big error token is null and hasnt been set
        // Send them to login screen to get another token
        startingview = [main instantiateInitialViewController];
        self.window.rootViewController = startingview;
        NSLog(@"TOKEN ERROR:: Token was returned Null from the NSUSERDEFAULTS\n");
    }
}

// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
- (void)applicationWillTerminate:(UIApplication *)application {}

// Build the request for getting a valid token
- (NSString*) buildTokenLoginRequest: (NSString*) tokenToCheck
{
    NSMutableString* valid = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [valid appendString:@"tokenlogin?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , tokenToCheck];
    
    [valid appendString:parameter1];
    
    NSLog(@"TOKEN INFO:: TokenLogin request:: %@", valid);
    
    return valid;
}

// Handles all Networking errors
// In both cases send them back to login screen
// NOTE:: may want to some how notify them that server didnt connect
-(void) didGetNetworkError: (NSNotification*) notif
{
    startingview = [main instantiateInitialViewController];
    
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        self.window.rootViewController = startingview;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        self.window.rootViewController = startingview;
    }
}

// If token is valid load the bypassLogin view (Tab Bar)
// If token is invalid send back to login screen
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@VALID_SUCCESS])
    {
        bypassLogin= [main instantiateViewControllerWithIdentifier:@"bypass"];
        self.window.rootViewController = bypassLogin;
        NSLog(@"TOKEN INFO:: Token has been confirmed by server - ALLOW BYPASS\n");
    }
    
    if([[notif name] isEqualToString:@INVALID_TOKEN])
    {
        startingview = [main instantiateInitialViewController];
        self.window.rootViewController = startingview;
        NSLog(@"TOKEN INFO:: Token has been devalidate by server\n");
    }
}


@end
