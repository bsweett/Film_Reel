//
//  InboxController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This view controller is used to controller the inbox tab. It contains a tableview and will
//  refresh a persons inbox if they pull down on it. Tapping on a cell in the inbox with data
//  will open a detail view for viewing the reel that was send to them.
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
 * This method is called when the InboxController is loaded for the first
 * time. It adds some observers for networking notifications gets the app delegate
 * and allocates the array of table elements. It also sets up the refresh controller
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shared = [AppDelegate appDelegate];
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
                                                name:@INBOX_SUCCESS
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@EMPTY_INBOX
                                              object:nil];
    
    [inboxTable setDelegate:self];
    [inboxTable setDataSource:self];
    
    inboxUpdate = [[Networking alloc] init];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [inboxTable addSubview:refreshControl];
    
    
    
    tablearray = [[NSMutableArray alloc] init];
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    tablearray = [currentLoggedIn objectForKey:@CURRENT_USER_INBOX];
}


/**
 * This method is called when the InboxController appears as the view.
 * It reloads the table view
 *
 * @param animated A BOOL sent from the view that called the transtion
 */
-(void)viewDidAppear:(BOOL)animated
{
    [inboxTable reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSUserDefaults* currentLoggedIn = [NSUserDefaults standardUserDefaults];
    [currentLoggedIn setObject:tablearray forKey:@CURRENT_USER_INBOX];
    [currentLoggedIn synchronize];
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
 * When the "sender" segaue is called this method will pass the reel object saved
 * over to the DetailView Controller so it can be used.
 *
 * @param segue The segue the will make the view change
 * @param sender This segue will be called from this view controller (self)
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"reelview"])
    {
        ReelView *dest = (ReelView *)[segue destinationViewController];
        dest.currentReel = sender;
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Network Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles a response from the Server. If its an empty inbox, stop refreshing
 * and do nothing. If some reels were found send copy them and throw them into
 * the table array, stop refreshing, and update the table.
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    
    // If no new mail just stop refreshing dont need to notify user
    if([[notif name] isEqualToString:@EMPTY_INBOX])
    {
        [refreshControl endRefreshing];
        LogInfo(@"INBOX INFO:: No new messages\n");
    }
    
    // If new mail is found add it to the table array and update
    if([[notif name] isEqualToString:@INBOX_SUCCESS])
    {
        LogInfo(@"INBOX INFO:: Got Data from Server\n");
        
        NSMutableArray* reels = [[notif userInfo] valueForKey:@INBOX_DATA];
        NSArray *copyArray    = [reels mutableCopy];
        
        [tablearray addObjectsFromArray:copyArray];
        
        [refreshControl endRefreshing];
        [inboxTable reloadData];
    }
}


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
        [refreshControl endRefreshing];
    }
    
    if([[notif name] isEqualToString:@ADDRESS_FAIL_ERROR])
    {
        LogError(@"Request Address was not URL formatted");
        [refreshControl endRefreshing];
    }
    
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [refreshControl endRefreshing];
        error = [[UIAlertView alloc] initWithTitle:nil
                                           message:@SERVER_CONNECT_ERROR
                                          delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:nil];
        [error show];
        [self performSelector:@selector(dismissErrors:) withObject:error afterDelay:3];
    }
}


/**
 * This function is a request Builder for getting inbox data. It builds and formats a string for
 * use in the Networking class.
 *
 * @param token The token of the current logged in user
 * @return inbox A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildInboxRequest: (NSString*) token
{
    NSMutableString* inbox = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [inbox appendString:@"getinbox?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    [inbox appendString:parameter1];
    
    LogInfo(@"REQUEST:: Get Inbox -- %@", inbox);
    
    return [inbox stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}


/**
 * Called when user pulls down to refresh the table view. Gets the request string
 * and passes it to Networking to handle.
 *
 */
- (void)refresh
{
    NSString* requestURL = [self buildInboxRequest:shared.appUser.token];
    [inboxUpdate startReceive:requestURL withType:@INBOX_REQUEST];
}


/**
 * Simple method of dimissing all alerts without buttons
 *
 * @param alert The alert is passed by the alertView we wish to dismiss
 */
-(void) dismissErrors:(UIAlertView*) alert { [alert dismissWithClickedButtonIndex:0 animated:YES]; }


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table View Data Source
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * A DataSource Method for a tableview returns the number of sections in
 * a table.
 *
 * @param tableView The UITableView whose datasource is set to this
 * @return 1 only one section in our tableview
 */
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView { return 1; }


/**
 * A DataSource Method for a tableview returns the number of rows in a section
 * in a table.
 *
 * @param tableView The UITableView whose datasource is set to this
 * @param section A section instance number
 * @return tableArray count The number of rows in a section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tablearray count];
}


/**
 * A DataSource Method for a tableview sets up cells' data and format.
 *
 * @param tableView The UITableView whose datasource is set to this
 * @param indexPath indexPath for a cell
 * @return cell A cell with a completed layout
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundView.opaque = NO;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.opaque = NO;
        cell.textLabel.textColor = [UIColor colorWithRed:0.050980396570000003 green:0.5411764979 blue:0.77647066119999997 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
        
        cell.accessoryView=UITableViewCellAccessoryNone;
    }
    
    // Set up the cell
    aReelForCell = [tablearray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat: @"Reel from %@" ,[aReelForCell getSender]];
    cell.imageView.image = [UIImage imageNamed:@"film-80.png"];
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table View Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * A Delegate method for the tableView. This is called everytime a user taps on
 * a cell that is in the table. It grabs the reel and preforms a segue to the 
 * detail view passing the reel object with it. It also deselects the row and 
 * deletes it from the table view.
 *
 * @param tableView The UITableView whose delegate is set to this
 * @param indexPath indexPath for a cell selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Reel *reel = [self.tablearray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tablearray removeObjectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"reelview" sender:reel];
}

@end
