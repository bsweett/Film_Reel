//
//  ProfileController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  One of the four tab views. This view controller controls the profile. It handles the displaying
//  of the current users information and the updating of it to the server. Users can also logout from
//  this view if they are not editing.
//

#import "ProfileController.h"

@interface ProfileController ()
@end

@implementation ProfileController

@synthesize bio;
@synthesize name;
@synthesize location;
@synthesize email;
@synthesize edit;
@synthesize cancel;
@synthesize imageButton;
@synthesize displaypicture;
@synthesize navigationItem;
@synthesize reelCount;

@synthesize star1, star2, star3, star4, star5;

@synthesize loading;
@synthesize error;
@synthesize Update;

@synthesize saveBio;
@synthesize saveLocation;
@synthesize saveName;
@synthesize savedImage;
@synthesize male;
@synthesize female;
@synthesize shared;
@synthesize maleHighlighted;
@synthesize femaleHighlighted;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

// NOTE:: This method has a bug. Profile image is being returned nil on Resume
/**
 * This method is called when the ProfileController is loaded for the first
 * time. It adds some observers for networking notifications gets the app delegate
 * and sets the users data to it.
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup background and display picture bounds
    [self.view sendSubviewToBack:[self background]];
    displaypicture.userInteractionEnabled = YES;
    displaypicture.contentMode = UIViewContentModeScaleAspectFill;
    displaypicture.clipsToBounds = YES;
    
    // Make gender images into gesture buttons
    UITapGestureRecognizer *maleTap =  [[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(malePushed:)];
    [maleTap setNumberOfTapsRequired:1];
    [male addGestureRecognizer:maleTap];
    
    UITapGestureRecognizer *femaleTap =  [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(femalePushed:)];
    [femaleTap setNumberOfTapsRequired:1];
    [female addGestureRecognizer:femaleTap];
    
    // Setup Observers for notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNetworkError:)
                                                 name:@ERROR_STATUS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNetworkError:)
                                                 name:@ADDRESS_FAIL
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetNetworkError:)
                                                 name:@FAIL_STATUS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSucceedRequest:)
                                                 name:@RESPONSE_FOR_POST
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSucceedRequest:)
                                                 name:@UPDATE_SUCCESS
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSucceedRequest:)
                                                 name:@USER_NOT_FOUND
                                               object:nil];
    
    // Editable Traits
    bio.editable      = NO;
    name.editable     = NO;
    location.editable = NO;
    email.editable    = NO;

    // Hide Cancel Button
    [[navigationItem leftBarButtonItem]setTitle:@"Logout"];
    
    // Disable Interaction with Gender
    imageButton.enabled           = NO;
    imageButton.hidden            = YES;
    male.userInteractionEnabled   = NO;
    female.userInteractionEnabled = NO;
    
    // Profile Data
    /////////////////////////////////////////////////////////////////////////
    
    // Set Delegates and get userdata
    bio.delegate      = self;
    name.delegate     = self;
    location.delegate = self;
    email.delegate = self;
    reelCount.delegate = self;
    
    shared = [AppDelegate appDelegate];
    
    // Set up values for profile feilds
    [[self bio] setText: [shared.appUser getUserBio]];
    [[self email] setText: [shared.appUser getEmail]];
    [[self name] setText: [shared.appUser getUserName]];
    [[self location] setText:[shared.appUser getLocation]];
    [[self displaypicture] setImage: [shared.appUser getDP]];
    [[self reelCount] setText:[shared.appUser getReelCount]];
    
    // Set up Boolean for Gender saving locally 
    if([[shared.appUser getGender] isEqualToString:@"M"])
    {
        male.highlighted = TRUE;
    }
    if([[shared.appUser getGender] isEqualToString:@"F"])
    {
        female.highlighted = TRUE;
    }
    if([[shared.appUser getGender] isEqualToString:@"U"])
    {
        female.highlighted = FALSE;
        male.highlighted = FALSE;
    }
    
    // Reformat all text based on device
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        [[self name] setFont:[UIFont systemFontOfSize:32]];
        [[self bio] setFont:[UIFont systemFontOfSize:20]];
        [[self location] setFont:[UIFont systemFontOfSize:20]];
        [[self email] setFont:[UIFont systemFontOfSize:22]];
        [[self reelCount] setFont:[UIFont systemFontOfSize:32]];
    }
    else
    {
        [[self name] setFont:[UIFont systemFontOfSize:30]];
        name.textAlignment = NSTextAlignmentCenter;
        [[self name] setTextColor:[UIColor blackColor]];
        [[self bio] setFont:[UIFont systemFontOfSize:12]];
        [[self bio] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0
                                                        green:92.0/255.0
                                                         blue:92.0/255.0
                                                        alpha:1]];
        [[self location] setFont:[UIFont systemFontOfSize:12]];
        [[self location] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0
                                                              green:92.0/255.0
                                                               blue:92.0/255.0
                                                              alpha:1]];
        [[self email] setFont:[UIFont systemFontOfSize:12]];
        email.textAlignment = NSTextAlignmentCenter;
        [[self email] setTextColor:[UIColor blackColor]];
    }
    [self setPopStars:shared.appUser.getPopularity];
    
    /////////////////////////////////////////////////////////////////////////
    // NOTE:: This is quite slow at the moment
    // The code however cannot go into the view did appear beacause alertview
    // count as new views and it is called again after an alert is popped over
    
    // Init Networking
    Update = [[Networking alloc] init];
    /*
    if([shared.appUser getDP] != nil)
    {
        [[self displaypicture] setImage:[shared.appUser getDP]];
    }
    else
    {
    */
        
        UIImage* getDpFromServer;
        if(shared.appUser.getDisplayPicturePath == nil)
        {
            LogError("Current User has null image path");
        }
        else
        {
            // Get displaypicture from server ... had issues with local copy
            getDpFromServer = [Update downloadImageFromServer:shared.appUser.getDisplayPicturePath];
        }
        
        if(getDpFromServer == nil)
        {
            [[self displaypicture]  setImage:[UIImage imageNamed:@"default.png"]];
        }
        else
        {
            [[self displaypicture]  setImage:getDpFromServer];
        }
    //}
    ///////////////////////////////////////////////////////////////////////////
}


/**
 * This method is called when the SelectFriendController appears as the view.
 * It gets all the friends user from the shared user in the app delegate adds
 * them to the table array and reloads the table data
 *
 * @param animated A BOOL sent from the view that called the transtion
 */
-(void)viewDidAppear:(BOOL)animated
{


    /////////////////////////////////////////////////////////////////////////
    
    // Init Networking
    Update = [[Networking alloc] init];
    
    
    UIImage* getDpFromServer;
    if(shared.appUser.getDisplayPicturePath == nil)
    {
        LogError("Current User has null image path");
    }
    else
    {
        // Get displaypicture from server ... had issues with local copy
         getDpFromServer = [Update downloadImageFromServer:shared.appUser.getDisplayPicturePath];
    }
                                
    if(getDpFromServer == nil)
    {
        [[self displaypicture]  setImage:[UIImage imageNamed:@"default.png"]];
    }
    else
    {
        [[self displaypicture]  setImage:getDpFromServer];
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
}


/**
* Removes iOS Status Bar ... strange issue with iPhone
*
*
*
*/
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
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


/**
 * Handles any response from the server. If user isnt found display an error
 * log and alert if user is found then prepare to update the rest of the 
 * info. If updating is finish dimiss notification
 *
 * @param notif The Notification that was sent from Networking
 */
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        LogError(@"SERVER:: User data could not be found for current user");
        [loading setMessage:@USER_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    
    if([[notif name] isEqualToString:@RESPONSE_FOR_POST])
    {
        NSDictionary* userDictionary = [notif userInfo];
        NSString* response= [userDictionary valueForKey:@POST_RESPONSE];
        
        if([response isEqualToString:@"Success"])
        {
            [self prepareForUpdate];
        }
        else
        {
            LogError(@"SERVER:: Could not upload profile picture");
            [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
        }
    }
    
    if([[notif name] isEqualToString:@UPDATE_SUCCESS])
    {
        [loading dismissWithClickedButtonIndex:0 animated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Action Handlers
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Handles what happens is the user taps the male icon if it is enabled
 *
 * @param recongnizer The tap recognizer from the viewDidLoad
 */
- (void)malePushed:(UIGestureRecognizer*) recognizer
{
    if(male.highlighted == FALSE)
    {
        male.highlighted = TRUE;
        female.highlighted = FALSE;
        [shared.appUser setGender: [NSMutableString stringWithFormat:@"M"]];
    }
}


/**
 * Handles what happens is the user taps the female icon if it is enabled
 *
 * @param recongnizer The tap recognizer from the viewDidLoad
 */
- (void)femalePushed:(UIGestureRecognizer*) recognizer
{
    if(female.highlighted == FALSE)
    {
        female.highlighted = TRUE;
        male.highlighted = FALSE;
        [shared.appUser setGender: [NSMutableString stringWithFormat:@"F"]];
    }
}


/**
 * Handles what happens when the user taps the edit or save button.
 * Disbales and enables the feilds accordingly. Uploads image to server
 * if it is change.
 *
 * @param sender The sender is self
 */
-(IBAction)doEdit:(id)sender
{
    if([[[navigationItem rightBarButtonItem]title] isEqualToString:@"Edit"])
    {
        [[navigationItem rightBarButtonItem] setTitle:@"Save"];
        [self saveValues];
        
        bio.editable = YES;
        location.editable = YES;
        [[navigationItem leftBarButtonItem]setTitle:@"Cancel"];
        imageButton.hidden = NO;
        imageButton.enabled = YES;
        male.userInteractionEnabled = YES;
        female.userInteractionEnabled = YES;
        
    } else  if([[[navigationItem rightBarButtonItem]title] isEqualToString:@"Save"])
    {
        [[navigationItem rightBarButtonItem] setTitle:@"Edit"];
        bio.editable = NO;
        location.editable = NO;
        [[navigationItem leftBarButtonItem]setTitle:@"Logout"];
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        male.userInteractionEnabled = NO;
        female.userInteractionEnabled = NO;
        
        // Update profile picture
        [Update saveImageToServer:UIImageJPEGRepresentation([shared.appUser getDP], 0.1f)
                     withFileName:[shared.appUser getEmail]];
    }
}


/**
 * Handles what happens when the user taps the cancel or logout button.
 * Disbales and enables the feilds accordingly. If logout then preform
 * an unwind segue to the login controller.
 *
 * @param sender The sender is self
 */
-(IBAction)doCancel:(id)sender
{
    if([[[navigationItem leftBarButtonItem]title] isEqualToString:@"Cancel"])
    {
        bio.editable = NO;
        location.editable = NO;
        [[navigationItem rightBarButtonItem] setTitle:@"Edit"];
        [[navigationItem leftBarButtonItem] setTitle:@"Logout"];
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        male.userInteractionEnabled = NO;
        female.userInteractionEnabled = NO;
        
        // undo changes
        [self resetViews];
    }
    else if([[[navigationItem leftBarButtonItem]title] isEqualToString:@"Logout"])
    {
        [shared.appUser setToken:nil];
        LogDebug(@"Testing logout");
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
}

/**
 * Handles what happens when the user taps the change image button
 * starts a picker controller.
 *
 * @param sender The sender is self
 */
-(IBAction)doImageTap:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Image Picker Controller
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Delegate method for image picker. Called when user is done selecting pic
 * save the pic to their defualts.
 *
 * @param picker The ImagePickerController being used
 * @param info  Dictionary of info sent back when it closes
 */
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [shared.appUser setDisplayPicture: info[UIImagePickerControllerEditedImage]];
    
    [self displaypicture].image = [shared.appUser getDP];
    [self.view bringSubviewToFront:[self displaypicture]];
}

/**
 * Delegate method for image picker. Called when user cancels the picker
 *
 * @param picker The ImagePickerController being used
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Profile interaction handling
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Saves local profile values before editing
 *
 */
-(void) saveValues
{
    saveBio = bio.text;
    saveLocation = location.text;
    savedImage = displaypicture.image;
    
    if(male.highlighted == TRUE)    { maleHighlighted = 1;   }
    if(female.highlighted == TRUE)  { femaleHighlighted = 1; }
    if(female.highlighted == FALSE && male.highlighted == FALSE)
    {
        femaleHighlighted = 0;
        maleHighlighted = 0;
    }
}

/**
 * reset the local values when they hit cancel
 *
 */
-(void) resetViews
{
    [[self bio] setText: saveBio];
    [[self location] setText:saveLocation];
    [[self displaypicture] setImage: savedImage];
    
    if(maleHighlighted == 1)
    {
        male.highlighted = TRUE;
        female.Highlighted = FALSE;
    }
    if(femaleHighlighted == 1)
    {
        female.highlighted = TRUE;
        male.highlighted = FALSE;
    }
    if(femaleHighlighted == 0 && maleHighlighted == 0)
    {
        male.highlighted = FALSE;
        female.highlighted = FALSE;
    }

}

/**
 * pass the data other than the image to the server when they 
 * are done updating. Shows an alert while updating
 *
 */
-(void) prepareForUpdate
{
    loading = [[UIAlertView alloc] initWithTitle:nil message:@"Updating"
                                        delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:nil, nil];
    NSString* updatedLocation = location.text;
    NSString* updatedBio = bio.text;
    NSString* updatedGender;
    
    if(male.highlighted == TRUE)
    {
        updatedGender = @"M";
    }
    if(female.highlighted == TRUE)
    {
        updatedGender = @"F";
    }
    if(female.highlighted == FALSE && male.highlighted == FALSE)
    {
        updatedGender = @"U";
    }
    
    [shared.appUser setLocation:[NSMutableString stringWithString:updatedLocation]];
    [shared.appUser setUserBio:[NSMutableString stringWithString:updatedBio]];
    [shared.appUser setGender: [NSMutableString stringWithString:updatedGender]];
    [shared.appUser setDisplayPicturePath: [shared.appUser getEmail]];
    [shared.appUser setDisplayPicture:displaypicture.image];

    NSString* request = [self buildProfileUpdateRequest:[shared.appUser getToken]
                                           withLocation:updatedLocation
                                                withBio:updatedBio
                                             withGender:updatedGender
                                               withPath:[shared.appUser getEmail]];
    
    [Update startReceive:request withType:@UPDATE_REQUEST];
    
    if ([Update isReceiving] == TRUE)
    {
        [loading show];
    }

}


/**
 * Sets the popularity stars based on the number set from server on
 * login.
 *
 * @paaram popular String containing pop number
 */
- (void) setPopStars: (NSMutableString*) popular
{
    if([popular isEqualToString:@"1"])
    {
        [[self star1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"2"])
    {
        [[self star1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"3"])
    {
        [[self star1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"4"])
    {
        [[self star1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
    else if([popular isEqualToString:@"5"])
    {
        [[self star1] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"star.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"star.png"]];
    }
    else
    {
        [[self star1] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star2] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star3] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star4] setImage:[UIImage imageNamed:@"stargrey.png"]];
        [[self star5] setImage:[UIImage imageNamed:@"stargrey.png"]];
    }
}

/**
 * This function is a request Builder for getting updating user data. It builds and formats a 
 * string for use in the Networking class.
 *
 * @param token The token of the current logged in user
 * @param geoLocation The location set by the user
 * @param about     The bio set by the user
 * @param gender    The gender set by the user
 * @param path      Name to save thier profile as
 * @return updateProfile A string encoded in UTF8 for sending to our Server as a URL
 */
- (NSString*) buildProfileUpdateRequest: (NSString*) token withLocation: (NSString*) geolocation
                                withBio: (NSString*) about withGender: (NSString*) gender
                               withPath: (NSString *) path
{
    NSMutableString* updateProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [updateProfile appendString:@"saveuserdata?"];
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&location=%@" , geolocation];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&bio=%@" , about];
    NSMutableString* parameter4 = [[NSMutableString alloc] initWithFormat: @"&gender=%@", gender];
    NSMutableString* parameter5 = [[NSMutableString alloc] initWithFormat: @"&path=%@", path];
    
    [updateProfile appendString:parameter1];
    [updateProfile appendString:parameter2];
    [updateProfile appendString:parameter3];
    [updateProfile appendString:parameter4];
    [updateProfile appendString:parameter5];
    
    LogInfo(@"REQUEST:: Update Profile -- %@", updateProfile);
    
    return [updateProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TextView Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView { return YES; }

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

@end
