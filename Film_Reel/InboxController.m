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
@synthesize inboxTable;
@synthesize error;
@synthesize inboxUpdate;
@synthesize shared;
@synthesize refreshControl;
@synthesize aReelForCell;

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
    
    shared = [AppDelegate appDelegate];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@INBOX_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@EMPTY_INBOX object:nil];
    
    [inboxTable setDelegate:self];
    
    inboxUpdate = [[Networking alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [inboxTable addSubview:refreshControl];
    
    tablearray = [[NSMutableArray alloc] init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) didSucceedRequest: (NSNotification*) notif
{
    
    // If no new mail just stop refreshing dont need to notify user
    if([[notif name] isEqualToString:@EMPTY_INBOX])
    {
        [refreshControl endRefreshing];
        NSLog(@"INBOX INFO:: No new messages\n");
    }
    
    // If new mail is found add it to the table array and update
    if([[notif name] isEqualToString:@INBOX_SUCCESS])
    {
        NSLog(@"INBOX INFO:: Got Data from Server\n");
        
        NSMutableArray* reels = [[notif userInfo] valueForKey:@INBOX_DATA];
        
        NSArray *copyArray = [reels mutableCopy];
        
        [tablearray addObjectsFromArray:copyArray];
        
        [refreshControl endRefreshing];
        
        // get data from notification and reload table with it
    }
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL_ERROR])
    {
        [refreshControl endRefreshing];
        error = [[UIAlertView alloc] initWithTitle:nil message:@ADDRESS_FAIL_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [refreshControl endRefreshing];
        error = [[UIAlertView alloc] initWithTitle:nil message:@SERVER_CONNECT_ERROR delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
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
    aReelForCell = [tablearray objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [aReelForCell getSender];
    
    return cell;
}

- (void)refresh
{
    NSString* requestURL = [self buildInboxRequest:shared.appUser.token];
    [inboxUpdate startReceive:requestURL withType:@INBOX_REQUEST];
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"reelview"]) {
        ReelView *dest = (ReelView *)[segue destinationViewController];
        //the sender is what you pass into the previous method
        dest.reel = sender;
    }
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get the reel
    Reel *reel = [self.tablearray objectAtIndex:indexPath.row];

    
    [self performSegueWithIdentifier:@"reelview" sender:reel];
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildInboxRequest: (NSString*) token
{
    NSMutableString* inbox = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [inbox appendString:@"inbox?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    
    [inbox appendString:parameter1];
    
    NSLog(@"REQUEST INFO:: Get Inbox -- %@", inbox);
    
    return [inbox stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}

@end
