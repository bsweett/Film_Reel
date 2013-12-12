//
//  FriendsController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

//Lets use unidirectional friendship. Much easier to implement
//When we send a snap to a friend if they do not have that person
//In their friends list then give them the option to add that person

#import "FriendsController.h"

@interface FriendsController ()

@end

@implementation FriendsController

@synthesize friendsTable;
@synthesize friendRequest;
@synthesize loading;
@synthesize addfriendalert;
@synthesize userdata;
@synthesize shared;
@synthesize tableElements;

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
 * This method is called when the ProfileController is loaded for the first
 * time. It adds some observers for networking notifications gets the app delegate
 * and sets the users data to it.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shared = [AppDelegate appDelegate];

    tableElements = [[shared.appUser.getFriendList allValues]
                     sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    friendRequest = [[Networking alloc] init];
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
                                                name:@FRIEND_SUCCESS
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@TOKEN_IS_INVALID_ADD_FRIEND
                                              object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didSucceedRequest:)
                                                name:@ALREADY_FRIENDS
                                              object:nil];
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
 * When the "sender" segaue is called this method will pass the friend email saved
 * over to the DetailView Controller so it can be used.
 *
 * @param segue The segue the will make the view change
 * @param sender This segue will be called from this view controller (self)
 */
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"detail"])
    {
        DetialViewController *dest = (DetialViewController *)[segue destinationViewController];
        dest.friendEmail = sender;
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Add Friend Action
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles the add friend button being pushed. Shows a alert dialog to use
 *
 * @param sender This segue will be called from this view controller (self)
 */
-(IBAction)doAddFriend:(id)sender
{
    addfriendalert = [[UIAlertView alloc] initWithTitle:@"Add a Friend"
                                                message:@"Enter a email to add: "
                                               delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"Add", nil];
    addfriendalert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [addfriendalert show];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark AlertView Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * AlertView delagate method that listens for a click at a button index. We
 * use it to send the friend request when the email is entered properly
 *
 * @param alertview The alertview being used
 * @param buttonIndex   Index of button pressed
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([self validateEmailWithString:[addfriendalert textFieldAtIndex:0].text])
        {
            NSString* req = [self buildAddRequest:[addfriendalert textFieldAtIndex:0].text
                                        withToken: [shared.appUser getToken]];
            
            loading = [[UIAlertView alloc] initWithTitle:nil message:@"Sending request..."
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil, nil];
            [friendRequest startReceive:req withType:@FRIEND_REQUEST];
            
            if([friendRequest isReceiving])
            {
                [loading show];
            }
            
        }
        else
        {
            [self dismissErrors:addfriendalert];
            loading = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid Email"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:nil, nil];
            [loading show];
            [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        }
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Network Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles response from server for adding a friend. If successful add them
 * to the users friend list and the table. If user isnt found display alert.
 * If already friends display an alert. If token is in valid kick them from app.
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{

    if([[notif name] isEqualToString:@FRIEND_SUCCESS])
    {
        [loading setMessage:@"Friend Added"];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        
        NSDictionary* userDictionary = [notif userInfo];
        User *friend = [userDictionary valueForKey:@CURRENT_USER];
        
        //Add the friends username to the friends list
        [shared.appUser addFriend:[friend getUserName] withEmail:[friend getEmail]];
        
        tableElements = [[shared.appUser.getFriendList allValues]
                         sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [self.friendsTable reloadData];
    }
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [loading setMessage:@USER_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    
    if([[notif name] isEqualToString:@ALREADY_FRIENDS])
    {
        [loading setMessage:@FRIEND_ALREADY_ERROR];
        //This does not show the already friends message just removed sending request dialouge
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    
    if([[notif name] isEqualToString:@TOKEN_IS_INVALID_ADD_FRIEND])
    {
        [loading setMessage:@INVALID_TOKEN_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        
        LogError(@"User trying to get friends has an invalid token");
        // kick them out of app
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
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        LogError(@"Request Address was not URL formatted");
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [loading setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
}


/**
 * Simple method of dimissing all alerts without buttons
 *
 * @param alert The alert is passed by the alertView we wish to dismiss
 */
-(void) dismissErrors:(UIAlertView*) alert { [alert dismissWithClickedButtonIndex:0 animated:YES]; }


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark String building and validation
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * This function is a request Builder for adding a friend. It builds and formats a
 * string for use in the Networking class.
 *
 * @param friendToAdd email of friend to add
 * @param token The token of current user
 * @return add A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildAddRequest: (NSString*) friendToAdd withToken: (NSString*) thisUser
{
    NSMutableString* add = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [add appendString:@"add?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , thisUser];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat:@"&femail=%@", friendToAdd];
    
    [add appendString:parameter1];
    [add appendString:parameter2];
    
    LogInfo(@"REQUEST:: Add friend -- %@", add);
    
    return [add stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


/**
 * This function checks to make sure the email entered is an actual email address
 *
 * @param emailAddress email of friend to check for
 * @return BOOL True if its a valid email, false if not
 */
- (BOOL)validateEmailWithString:(NSString*)emailaddress
{
    if(emailaddress.length >= MIN_EMAIL_ENTRY && emailaddress.length <= MAX_EMAIL_ENTRY)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL result = [emailTest evaluateWithObject:emailaddress];
        return result;
    }
    
    return FALSE;
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableView Datasource
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * A DataSource Method for a tableview returns the number of rows in a section
 * in a table.
 *
 * @param tableView The UITableView whose datasource is set to this
 * @param section A section instance number
 * @return tableArray count The number of rows in a section.
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor                = [UIColor lightGrayColor];
        cell.selectionStyle                 = UITableViewCellSelectionStyleBlue;
        cell.backgroundView.opaque          = NO;

        cell.textLabel.backgroundColor      = [UIColor clearColor];
        cell.textLabel.opaque               = NO;
        cell.textLabel.textColor            = [UIColor colorWithRed:0.050980396570000003
                                                   green:0.5411764979
                                                    blue:0.77647066119999997
                                                   alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font                 = [UIFont boldSystemFontOfSize:18];
        
        
        cell.accessoryView=UITableViewCellAccessoryNone;
        
    }
    
    // Set up the cell...
    cell.textLabel.text = [tableElements objectAtIndex:indexPath.row];
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TableView Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * A Delegate method for the tableView. This is called everytime a user taps on
 * a cell that is in the table. It grabs the user and preforms a segue to the
 * detail view. It also deselects the row.
 *
 * @param tableView The UITableView whose delegate is set to this
 * @param indexPath indexPath for a cell selected
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get senders name
    NSString* name = [self.tableElements objectAtIndex:indexPath.row];
    
    //Gets the email address for the local friend
    //Friends names will be updated locally when a login occurs
    NSString* recipient = [[shared.appUser.getFriendList allKeysForObject:name] objectAtIndex:0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"detail" sender:recipient];
}

@end
