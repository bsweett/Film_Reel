//
//  InboxController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "InboxController.h"

@interface InboxController ()

@end

@implementation InboxController

@synthesize tablearray;
@synthesize indox;
@synthesize loading;
@synthesize inboxUpdate;

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
    tablearray = [[NSMutableArray alloc] init];
    [tablearray addObject:@"Ben"];
}

-(void)viewDidAppear:(BOOL)animated
{
    inboxUpdate = [[Networking alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@INBOX_SUCCESS object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@INBOX_SUCCESS])
    {
        NSLog(@"Profile action succeed\n");
        [loading dismissWithClickedButtonIndex:0 animated:YES];
    }
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL_ERROR])
    {
        [loading setMessage:@ADDRESS_FAIL_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [loading setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
}

// Dismiss dialogs when done
-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tablearray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundView.opaque = NO;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.opaque = NO;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];

        
        cell.accessoryView=UITableViewCellAccessoryNone;
        
    }
    
    // Set up the cell...
    cell.textLabel.text = [tablearray objectAtIndex:indexPath.row];
    
    return cell;
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildInboxRequest: (NSString*) token
{
    NSMutableString* inbox = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [inbox appendString:@"inbox?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    
    [inbox appendString:parameter1];
    
    NSLog(@"Inbox request:: %@", inbox);
    
    return inbox;
}

@end
