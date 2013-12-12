//
//  DetialViewController.m
//  Film_Reel
//
//  Created by Brayden Girard on 12/1/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This is a detail view that is called when a user selects a friend's name from the list.
//  On load grab user data before displaying thier profile.
//

#import "DetialViewController.h"

@interface DetialViewController ()

@end

@implementation DetialViewController

@synthesize friendEmail;
@synthesize friendUser;

@synthesize name;
@synthesize email;
@synthesize location;
@synthesize bio;
@synthesize male;
@synthesize female;

@synthesize friendstar1, friendstar2, friendstar3, friendstar4, friendstar5;

@synthesize getProfile;
@synthesize error;
@synthesize indicator;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


/**
 * This method is called when the DetailViewController is loaded for the first
 * time. Adds obesrvers, sets up indicator, and starts networking to grab a
 * users profile
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
                                                name:@USER_NOT_FOUND
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@DATA_SUCCESS
                                              object:nil];
    
    getProfile = [[Networking alloc] init];
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setFrame:self.view.frame];
    CGPoint center = self.view.center;
    indicator.center = center;
    [indicator.layer setBackgroundColor:[[UIColor colorWithWhite:0.0 alpha:0.30] CGColor]];
    [self.view addSubview:indicator];
    
    if(friendEmail != nil)
    {
        NSString* profileRequest = [self buildFriendDataRequest:friendEmail];
        [getProfile startReceive:profileRequest withType:@DATA_REQUEST];
        
        if([getProfile isReceiving])
        {
            self.navigationController.navigationBar.userInteractionEnabled=NO;
            [indicator startAnimating];
        }
    }
    else
    {
        LogError(@"FRIEND:: Friend's detial view was sent a NULL Email");
    }
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
 * If Data was sent correctly display it and format it. If not
 * its a bad error.
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@DATA_SUCCESS])
    {
        NSDictionary* userDictionary = [notif userInfo];
        friendUser = [userDictionary valueForKey:@FRIEND_USER];
        
        [[self name] setText:[friendUser getUserName]];
        [[self email] setText:[friendUser getEmail]];
        [[self bio] setText:[friendUser getUserBio]];
        [[self location] setText:[friendUser getLocation]];
        [self setPopStars:[friendUser getPopularity]];
        [[self reelCount] setText:[friendUser getReelCount]];
        
        // Set up Boolean for Gender saving locally
        if([[friendUser getGender] isEqualToString:@"M"])
        {
            male.highlighted = TRUE;
        }
        if([[friendUser getGender] isEqualToString:@"F"])
        {
            female.highlighted = TRUE;
        }
        if([[friendUser getGender] isEqualToString:@"U"])
        {
            female.highlighted = FALSE;
            male.highlighted = FALSE;
        }
        
        name.textAlignment = NSTextAlignmentCenter;
        email.textAlignment = NSTextAlignmentCenter;
        
        // Reformat all text
        if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            [[self name] setFont:[UIFont systemFontOfSize:32]];
            [[self bio] setFont:[UIFont systemFontOfSize:20]];
            [[self location] setFont:[UIFont systemFontOfSize:20]];
            [[self email] setFont:[UIFont systemFontOfSize:22]];
        }
        else
        {
            [[self name] setFont:[UIFont systemFontOfSize:22]];
            [[self name] setTextColor:[UIColor blackColor]];
            [[self bio] setFont:[UIFont systemFontOfSize:12]];
            [[self bio] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1]];
            [[self location] setFont:[UIFont systemFontOfSize:12]];
            [[self location] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1]];
            [[self email] setFont:[UIFont systemFontOfSize:18]];
            [[self email] setTextColor:[UIColor blackColor]];
        }
        
        UIImage* friendsPic = [getProfile downloadImageFromServer:[friendUser getDisplayPicturePath]];
        
        // If pic is null report error and make set it to default
        if(friendsPic != nil)
        {
            [[self displayPicture] setImage: friendsPic];
        }
        else
        {
            [[self displayPicture] setImage: [UIImage imageNamed:@"default.png"]];
            LogError(@"FRIEND:: Could not load profile image from server");
        }
        
        [indicator stopAnimating];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
    
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@"User Data not found" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
        
        LogError(@"SERVER:: A friends user data was not returned from the server");
         self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Other Methods
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Sets the popularity stars based on the number set from grabbing friend
 * data
 *
 * @paaram popular String containing pop number
 */
- (void) setPopStars: (NSMutableString*) popular
{
    if([popular isEqualToString:@"1"])
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"2"])
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"3"])
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"4"])
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"5"])
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"star.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"star.png"]];
    }
    else
    {
        [[self friendstar1] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar2] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self friendstar5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
}


/**
 * This function is a request Builder for grabing friends data. It builds and
 * formats a string for use in the Networking class.
 *
 * @param anEmail email of a friend
 * @return friendData A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildFriendDataRequest: (NSString*) anEmail
{
    NSMutableString* friendData = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [friendData appendString:@"getfrienddata?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"email=%@" , anEmail];
    
    [friendData appendString:parameter1];
    
    LogInfo(@"REQUEST:: Get Friend Data --  %@", friendData);
    
    return [friendData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
