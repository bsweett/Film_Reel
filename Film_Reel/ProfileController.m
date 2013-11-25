//
//  ProfileController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
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

@synthesize loading;
@synthesize error;
@synthesize updateOrFetch;

@synthesize saveBio;
@synthesize saveLocation;
@synthesize saveName;
@synthesize savedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        bio.editable = NO;
        name.editable = NO;
        location.editable = NO;
        email.editable = NO;
        cancel.enabled = NO;
        cancel.hidden = YES;
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        [edit setTitle:@"Edit" forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bio.delegate = self;
    name.delegate = self;
    location.delegate = self;
    email.delegate = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@"AddressFailed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@"FailStatus" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@"FETCH_COMPLETE" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@"UPDATE" object:nil];
    
    updateOrFetch = [[Networking alloc] init];
    
    // Build URL
    // NEED TO PASS TOKEN OF CURRENT LOGGED IN USER
    NSString* request = [self buildFetchRequest:@""];
    
    // NOTE:: Comment this out to bypass networking
    [updateOrFetch startReceive:request withType:@FETCH_REQUEST];
    
    // Set up alert dialog
    loading = [[UIAlertView alloc] initWithTitle:nil message:@"Loading..." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    // Animate it
    if([updateOrFetch isReceiving] == TRUE)
    {
        [loading show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handles all Networking errors that come from Networking.m
-(void) didGetNetworkError: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@"AddressFailed"])
    {
        NSLog(@"Wrong Address\n");
        
        [loading setMessage:@ADDRESS_FAIL_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    if([[notif name] isEqualToString:@"FailStatus"])
    {
        NSLog(@"Failed to connect\n");

        [loading setMessage:@SERVER_CONNECT_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
}

-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// Handles Succussful fetching of profile
// May want to pass the something through notification to check which request was actually made
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@"UPDATE"])
    {
        NSLog(@"Profile action succeed\n");
        [loading dismissWithClickedButtonIndex:0 animated:YES];
        //[self performSegueWithIdentifier:@"done" sender:self];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor grayColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
}

-(IBAction)doEdit:(id)sender
{
    if([[edit currentTitle] isEqualToString:@"Edit"])
    {
        [edit setTitle:@"Save" forState:UIControlStateNormal];
        
        [self saveValues];
        
        bio.editable = YES;
        name.editable = YES;
        location.editable = YES;
        cancel.hidden = NO;
        cancel.enabled = YES;
        imageButton.hidden = NO;
        imageButton.enabled = YES;
        
    } else  if([[edit currentTitle] isEqualToString:@"Save"])
    {

        [edit setTitle:@"Edit" forState:UIControlStateNormal];
        bio.editable = NO;
        name.editable = NO;
        location.editable = NO;
        cancel.enabled = NO;
        cancel.hidden = YES;
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        
        // Validate new Username
        if([self validateUserNameWithString:name.text] == TRUE)
        {
            [self prepareForUpdate];
        }
        else
        {
            error = [[UIAlertView alloc] initWithTitle:nil message:@"Username can only contain letters and numbers (4-30)\n" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [error show];
        }
    }
}

-(IBAction)doCancel:(id)sender
{
    if([[edit currentTitle] isEqualToString:@"Save"])
    {
        [edit setTitle:@"Edit" forState:UIControlStateNormal];
        bio.editable = NO;
        name.editable = NO;
        location.editable = NO;
        cancel.hidden = YES;
        cancel.enabled = NO;
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        
        // undo changes
        [self resetViews];
    }
}

// Make sure new username conforms to our signup rules
- (BOOL)validateUserNameWithString:(NSString*)username
{
    if( username.length >= MIN_ENTRY_SIZE && username.length <= MAX_USERNAME_ENTRY )
    {
        NSString *nameRegex = @"[A-Z0-9a-z]*";
        NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
        return [nameTest evaluateWithObject:username];
    }
    
    return FALSE;
}

// Allow them to pick an image for their profile
-(IBAction)doImageTap:(id)sender
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.displaypicture.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


//Store local values in case they hit cancel
-(void) saveValues
{
    saveBio = bio.text;
    saveLocation = location.text;
    saveName = name.text;
    savedImage = displaypicture.image;
}

// reset the local values when they hit cancel
-(void) resetViews
{
    bio.text = saveBio;
    location.text = saveLocation;
    name.text = saveName;
    displaypicture.image = savedImage;
}

// get ready to pass the update to the server
-(void) prepareForUpdate
{
    
    NSString* updatedName = name.text;
    NSString* updatedLocation = location.text;
    NSString* updatedBio = bio.text;
    
    // For now dp wont be updated
    //UIImage* updatedPic = displaypicture.image;
    
    
    NSString* request = [self buildProfileUpdateRequest:@"" withUserName:updatedName withLocation:updatedLocation withBio:updatedBio];
    // Need to pass current logged in users token -------^
    
    [updateOrFetch startReceive:request withType:@UPDATE_REQUEST];
    
    if ([updateOrFetch isReceiving] == TRUE)
    {
        [loading show];
    }
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildProfileUpdateRequest: (NSString*) token withUserName: (NSString*) username withLocation: (NSString*) geolocation withBio: (NSString*) about
{
    NSMutableString* updateProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [updateProfile appendString:@"update?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&name=%@" , username];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&location=%@" , geolocation];
    NSMutableString* parameter4 = [[NSMutableString alloc] initWithFormat: @"&bio=%@" , about];
    
    [updateProfile appendString:parameter1];
    [updateProfile appendString:parameter2];
    [updateProfile appendString:parameter3];
    [updateProfile appendString:parameter4];
    
    NSLog(@"Update Profile request:: %@", updateProfile);
    
    return updateProfile;
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildFetchRequest: (NSString*) token
{
    NSMutableString* fetchProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [fetchProfile appendString:@"fetchProfile?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    
    [fetchProfile appendString:parameter1];
    
    NSLog(@"Fetch Profile request:: %@", fetchProfile);
    
    return fetchProfile;
}

@end
