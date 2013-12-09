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

    tableElements = [[shared.appUser.getFriendList allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    friendRequest = [[Networking alloc] init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@FRIEND_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@TOKEN_IS_INVALID_ADD_FRIEND object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@ALREADY_FRIENDS object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doAddFriend:(id)sender
{
    addfriendalert = [[UIAlertView alloc] initWithTitle:@"Add a Friend" message:@"Enter a email to add: " delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    addfriendalert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //addfriendalert
    [addfriendalert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if([self validateEmailWithString:[addfriendalert textFieldAtIndex:0].text])
        {
            NSString* req = [self buildAddRequest:[addfriendalert textFieldAtIndex:0].text withToken: [shared.appUser getToken]];
            
            loading = [[UIAlertView alloc] initWithTitle:nil message:@"Sending request..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [friendRequest startReceive:req withType:@FRIEND_REQUEST];
            
            if([friendRequest isReceiving])
            {
                [loading show];
            }
            
        } else
        {
            [self dismissErrors:addfriendalert];
            loading = [[UIAlertView alloc] initWithTitle:nil message:@"Invalid Email" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [loading show];
            [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        }
    }
}

// Handles Succussful acount creation
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
        
        tableElements = [[shared.appUser.getFriendList allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
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
        // Kick them from application
    }
    
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [loading setMessage:@ADDRESS_FAIL_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
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

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildAddRequest: (NSString*) friendToAdd withToken: (NSString*) thisUser
{
    NSMutableString* add = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [add appendString:@"add?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , thisUser];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat:@"&femail=%@", friendToAdd];
    
    [add appendString:parameter1];
    [add appendString:parameter2];
    
    NSLog(@"REQUEST INFO:: Add friend -- %@", add);
    
    return [add stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableElements count];
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Get senders name
    NSString* name = [self.tableElements objectAtIndex:indexPath.row];
   
    //Gets the email address for the local friend
    //Friends names will be updated locally when a login occurs
    NSString* recipient = [[shared.appUser.getFriendList allKeysForObject:name] objectAtIndex:0];
    
    [self performSegueWithIdentifier:@"detail" sender:recipient];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"detail"])
    {
        DetialViewController *dest = (DetialViewController *)[segue destinationViewController];
        dest.friendEmail = sender;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
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
    
    // Set up the cell...
    cell.textLabel.text = [tableElements objectAtIndex:indexPath.row];
    
    return cell;
}

@end
