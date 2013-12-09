//
//  SelectFriendController.m
//  Film_Reel
//
//  Created by Ben Sweett on 11/29/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This view controller is only accessible from the CameraController / Take a Reel Tab. It contains
//  a tableview with all of the users friends. If the user selects one this class will upload the
//  reel and then make a SendReel request to the server with some information.
//

#import "SelectFriendController.h"

@interface SelectFriendController ()

@end

@implementation SelectFriendController

@synthesize alert;
@synthesize sendReelRequest;
@synthesize imageToSend;
@synthesize tableElements;
@synthesize shared;

@synthesize selectedFriend;
@synthesize sendersEmail;
@synthesize recepient;
@synthesize ImageFileName;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}


/**
 * This method is called when the SelectFriendController is loaded for the first
 * time. It adds some observers for networking notifications gets the app delegate
 * and allocates the array of table elements.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableElements = [[NSArray alloc]init];
    shared        = [AppDelegate appDelegate];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didGetNetworkError:)
                                                name:@ERROR_STATUS
                                              object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSucceedRequest:)
                                                 name:@RESPONSE_FOR_POST
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSucceedRequest:)
                                                 name:@REEL_SUCCESS
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNetworkError:)
                                                 name:@ADDRESS_FAIL
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNetworkError:)
                                                 name:@FAIL_STATUS
                                               object:nil];
}


/**
 * This method is called when the SelectFriendController appears as the view.
 * It gets all the friends user from the shared user in the app delegate adds 
 * them to the table array and reloads the table data
 *
 * @param animated A BOOL sent from the view that called the transtion
 */
- (void) viewDidAppear:(BOOL)animated
{
    tableElements = [[shared.appUser.getFriendList allValues]
                     sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
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
#pragma mark Table View Data Source
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * A DataSource Method for a tableview returns the number of sections in
 * a table. We could add Sorting by Aplhabet here to clean up tables with 
 * lots of users.
 *
 * @param tableView The UITableView whose datasource is set to this
 * @return 1 For now only one section in our tableview
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }


/**
 * A DataSource Method for a tableview returns the number of rows in a section
 * in a table. 
 *
 * @param tableView The UITableView whose datasource is set to this
 * @param section A section instance number
 * @return tableElements count The number of rows in a section.
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableElements count];
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundView.opaque = NO;
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.opaque = NO;
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:128 blue:225 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        
        cell.accessoryView=UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [tableElements objectAtIndex:indexPath.row];
    // Could add friends profiles here
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table View Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * A Delegate method for the tableView. This is called everytime a user taps on 
 * a cell that is in the table. It grabs the users email and sends uploads a reel
 * to the server. Shows an alert while doing this.
 *
 * @param tableView The UITableView whose delegate is set to this
 * @param indexPath indexPath for a cell selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    sendReelRequest = [[Networking alloc] init];
    alert = [[UIAlertView alloc] initWithTitle:nil
                                message:@"Sending..."
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil, nil];
    
    // Get sender and reciepent
    selectedFriend = [self.tableElements objectAtIndex:indexPath.row];
    recepient = [[shared.appUser.getFriendList allKeysForObject:selectedFriend] objectAtIndex:0];
    sendersEmail = [shared.appUser getEmail];
    
    // Build the filename for image and upload it
    NSString* fileName = [self buildImageFileName:recepient];
    [sendReelRequest saveImageToServer:imageToSend withFileName:fileName];
    [alert show];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Networking Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles a response from the Server. If its a success from a upload it
 * sends another request and posts some reel information to the inbox on 
 * the server. If its a success at everything it tells the user the message 
 * was sent.
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@RESPONSE_FOR_POST])
    {
        NSString* response = [[notif userInfo] valueForKey:@POST_RESPONSE];
        
        if([response isEqualToString:@"Success"])
        {
            
            LogInfo(@"SERVER:: Upload of reel was successful");
            if(ImageFileName != nil && sendersEmail != nil && recepient != nil)
            {
                NSString* request = [self buildSendRequest:sendersEmail
                                                withFriend:recepient
                                         withImageFileName:ImageFileName];
                [sendReelRequest startReceive:request withType:@REEL_SEND];
            }
            else
            {
                LogError(@"REEL ERROR:: ImageFileName, sendersEmail, or recepient are null");
            }
            
        }
        else
        {
            LogError(@"SERVER ERROR:: Failed to upload reel to server");
            [alert setMessage:@"Reel failed to upload to server"];
            [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        }
    }
    
    if([[notif name] isEqualToString:@REEL_SUCCESS])
    {
        [alert setMessage:@"Message Sent"];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        LogError(@"Request Address was not URL formatted");
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [alert setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


/**
 * Simple method of dimissing all alerts without buttons
 *
 * @param x The x is passed by the alertView we wish to dismiss
 */
-(void)dismissErrors: (UIAlertView*)x { [x dismissWithClickedButtonIndex:-1 animated:YES]; }


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Building filename and Requests
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * This function is a filename builder for a reel image that is to be stored on the server
 * A file name is made of a recievers email and a timestamp
 *
 * @param recipient The email of the user that is going to get the reel
 * @return imageFileName A filename for the image to be saved as
 */
- (NSString*) buildImageFileName: (NSString*) recipient
{
    ImageFileName                   = [[NSMutableString alloc] initWithString:recepient];

    NSDate* currentTimeStamp        = [NSDate date];
    NSDateFormatter * datefromatter = [[NSDateFormatter alloc] init];
    [datefromatter setDateFormat:@"dd.MM.YY$HH:mm:ss"];
    NSString* dateString            = [datefromatter stringFromDate:currentTimeStamp];
    
    [ImageFileName appendString:@"@"];
    [ImageFileName appendString:dateString];
    
    LogInfo(@"REEL:: created filename for Reel -- %@", ImageFileName);
    
    return ImageFileName;
}


/**
 * This function is a request Builder for sending reel info. It builds and formats a string for
 * use in the Networking class.
 *
 * @param sender The email of the user sending the reel
 * @param receiver The email of the user that is receiving the reel
 * @param imageName The filename of the image that is already stored
 * @return send A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildSendRequest: (NSString*) sender withFriend: (NSString*) receiver withImageFileName: (NSString*) imageName
{
    NSMutableString* send = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [send appendString:@"send?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"from=%@" , sender];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&to=%@" , receiver];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&imagelocation=%@" , imageName];
    
    [send appendString:parameter1];
    [send appendString:parameter2];
    [send appendString:parameter3];
    
    LogInfo(@"REQUEST:: Send Reel -- %@", send);
    
    return [send stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
