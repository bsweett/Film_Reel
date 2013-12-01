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
@synthesize getProfile;
@synthesize loading;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_ALREADY_EXISTS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@SIGNUP_SUCCESS object:nil];
    
    getProfile = [[Networking alloc] init];
    loading = [[UIAlertView alloc] initWithTitle:nil message:@"Loading..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    if(friendEmail != nil)
    {
        NSString* profileRequest = [self buildFriendDataRequest:friendEmail];
        [getProfile startReceive:profileRequest withType:@DATA_REQUEST];
        
        if([getProfile isReceiving])
        {
            [loading show];
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
