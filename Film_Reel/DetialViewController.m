//
//  DetialViewController.m
//  Film_Reel
//
//  Created by Brayden Girard on 12/1/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "DetialViewController.h"

@interface DetialViewController ()

@end

@implementation DetialViewController

@synthesize friendEmail;
@synthesize friendUser;

@synthesize friendstar1, friendstar2, friendstar3, friendstar4, friendstar5;

@synthesize getProfile;
@synthesize error;
@synthesize indicator;

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_NOT_FOUND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@DATA_SUCCESS object:nil];
    
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
        NSLog(@"ERROR:: Friend's detial view was sent a NULL Email");
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
         self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@SERVER_CONNECT_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
         self.navigationController.navigationBar.userInteractionEnabled=YES;
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
    if([[notif name] isEqualToString:@DATA_SUCCESS])
    {
        NSDictionary* userDictionary = [notif userInfo];
        friendUser = [userDictionary valueForKey:@FRIEND_USER];
        
        [[self name] setText:[friendUser getUserName]];
        [[self email] setText:[friendUser getEmail]];
        [[self bio] setText:[friendUser getUserBio]];
        [[self location] setText:[friendUser getLocation]];
        [self setPopStars:[friendUser getPopularity]];
        
        [indicator stopAnimating];
        self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
    
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [indicator stopAnimating];
        error = [[UIAlertView alloc] initWithTitle:nil message:@"User Data not found" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
         self.navigationController.navigationBar.userInteractionEnabled=YES;
    }
}

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

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildFriendDataRequest: (NSString*) email
{
    NSMutableString* friendData = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [friendData appendString:@"getfrienddata?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"email=%@" , email];
    
    [friendData appendString:parameter1];
    
    NSLog(@"REQUEST INFO:: Get Friend Data --  %@", friendData);
    
    return [friendData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
