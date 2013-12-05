//
//  SelectFriendController.m
//  Film_Reel
//
//  Created by Ben Sweett on 11/29/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableElements = [[NSArray alloc]init];
    shared = [AppDelegate appDelegate];
    
    // Networking Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSucceedRequest:) name:@RESPONSE_FOR_POST object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSucceedRequest:) name:@REEL_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated {
    tableElements = [[shared.appUser.getFriendList allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [tableElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
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
    
    
    // Configure the cell...
    
    cell.textLabel.text = [tableElements objectAtIndex:indexPath.row];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
/*
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)path
{
    // Determine if row is selectable based on the NSIndexPath.
    // TODO
    BOOL rowIsSelectable = FALSE;
    
    if (rowIsSelectable)
    {
        return path;
    }
    
    return nil;
}
*/
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    sendReelRequest = [[Networking alloc] init];

    alert = [[UIAlertView alloc] initWithTitle:nil
                                message:@"Sending..."
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:nil, nil];
    
    //Get senders name
    selectedFriend = [self.tableElements objectAtIndex:indexPath.row];
    
    // MAKE SURE CELLS ARE NOT SELECTABLE IF THEY ARENT FILLED IN
    // Fill them in from friendlist
    // TODO
    
    [sendReelRequest saveImageToServer:imageToSend withPostType:@REEL_IMAGE];
    [alert show];
}

- (NSString*) buildImagePath: (NSString*) sender withRecipient: (NSString*) recipient
{
    return @"";
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildSendRequest: (NSString*) sender withFriend: (NSString*) receiver withImagePath: (NSString*) imagePath
{
    NSMutableString* send = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [send appendString:@"send?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"from=%@" , sender];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&to=%@" , receiver];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&image=%@" , imagePath];
    
    [send appendString:parameter1];
    [send appendString:parameter2];
    [send appendString:parameter3];
    
    NSLog(@"REQUEST INFO:: Send Reel -- %@", send);
    
    return send;
}

// Handles Succussful Server connection
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@RESPONSE_FOR_POST])
    {
        NSDictionary* userDictionary = [notif userInfo];
        NSString* response = [userDictionary valueForKey:@POST_RESPONSE];
        
        if([response isEqualToString:@""])
        {
            NSString* recipient = [[shared.appUser.getFriendList allKeysForObject:selectedFriend] objectAtIndex:0];
            NSString* currentUserEmail = [shared.appUser getEmail];
            NSString* path = [self buildImagePath:currentUserEmail withRecipient:recipient];
            
            NSString* request = [self buildSendRequest:currentUserEmail withFriend:recipient withImagePath:path];
            //[sendReelRequest startReceive:request withType:@REEL_SEND];
        }
        else
        {
            NSLog(@"SERVER ERROR:: Failed to upload reel to server");
        }
    }
    if([[notif name] isEqualToString:@REEL_SUCCESS])
    {
        [alert setMessage:@"Message Sent"];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        //[self.navigationController popToViewController:destView animated:<#(BOOL)#>];
    }
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@ADDRESS_FAIL])
    {
        [alert setMessage:@ADDRESS_FAIL_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        //[self.navigationController popViewControllerAnimated:YES];
    }
    if([[notif name] isEqualToString:@FAIL_STATUS])
    {
        [alert setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:3];
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dismissErrors: (UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}

@end
