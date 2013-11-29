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

@synthesize currentUsersToken;
@synthesize userdata;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Hello!!!");
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@FETCH_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@UPDATE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_NOT_FOUND object:nil];
    
    bio.delegate = self;
    name.delegate = self;
    location.delegate = self;
    email.delegate = self;
    AppDelegate* shared = [AppDelegate appDelegate];
    userdata = shared.appUser;
    
    updateOrFetch = [[Networking alloc] init];
    
    // Build URL
    NSString* request = [self buildFetchRequest:currentUsersToken];
    
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

-(void)viewDidAppear:(BOOL)animated
{
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void) dismissErrors:(UIAlertView*) alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

// Handles Succussful fetching of profile
// May want to pass the something through notification to check which request was actually made
-(void) didSucceedRequest: (NSNotification*) notif
{
    if([[notif name] isEqualToString:@USER_NOT_FOUND])
    {
        [loading setMessage:@USER_ERROR];
        [self performSelector:@selector(dismissErrors:) withObject:loading afterDelay:3];
    }
    
    if([[notif name] isEqualToString:@UPDATE_SUCCESS])
    {
        NSDictionary* userDictionary = [notif userInfo];
        userdata = [userDictionary valueForKey:@CURRENT_USER];
        [loading dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if([[notif name] isEqualToString:@FETCH_SUCCESS])
    {
        NSDictionary* userDictionary = [notif userInfo];
        userdata = [userDictionary valueForKey:@CURRENT_USER];
        [[self bio] setText: userdata.getUserBio];
        [[self name] setText: userdata.getUserName];
        [[self location] setText:userdata.getLocation];
        [[self email] setText: userdata.getEmail];
        
        //Code for image sending
        /*
        if([userdata.imagePath isEqualToString:@"unknown"]) {
            userdata.displayPicture = [[UIImage alloc] initWithContentsOfFile:@"default.png"];
            [[self displaypicture] setImage:userdata.displayPicture];
        }
        
        else {
            UIImage *image = [self decodeBase64ToImage:userdata.imagePath];
            userdata.displayPicture = image;
            [[self displaypicture] setImage:userdata.displayPicture];
        }
         
         */
        
        // Reformat all text
        if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
        {
            [[self name] setFont:[UIFont systemFontOfSize:20]];
            [[self name] setTextColor:[[UIColor alloc] initWithRed:0.050980396570000003 green:0.5411764979 blue:0.77647066119999997 alpha:1]];
            [[self bio] setFont:[UIFont systemFontOfSize:14]];
            [[self location] setFont:[UIFont systemFontOfSize:14]];
            [[self email] setFont:[UIFont systemFontOfSize:14]];
        }
        else
        {
            // iPhone Formating 
        }
        
        //saveImage =....
        [loading dismissWithClickedButtonIndex:0 animated:YES];
        
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
        if([self validateUserNameWithString:(name.text)] == TRUE)
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
    userdata.displayPicture = info[UIImagePickerControllerEditedImage];;
    [[self displaypicture] setImage:userdata.displayPicture];
    
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
    [[self bio] setText: saveBio];
    [[self location] setText:saveLocation];
    [[self name] setText:saveName];
    [[self displaypicture] setImage: savedImage];
}

// get ready to pass the update to the server
-(void) prepareForUpdate
{
    
    NSString* updatedName = name.text;
    NSString* updatedLocation = location.text;
    NSString* updatedBio = bio.text;
    
    //Code for image sending
    /*
    NSString *encodedImage = [self encodeToBase64String:userdata.displayPicture];
    */
    
    //Temp for now normally would get display picture as above
    NSString *tempImage = @"default";
    
    NSString* request = [self buildProfileUpdateRequest:currentUsersToken withUserName:updatedName withImage:tempImage withLocation:updatedLocation withBio:updatedBio];
    // Need to pass current logged in users token -------^
    
    [updateOrFetch startReceive:request withType:@UPDATE_REQUEST];
    
    if ([updateOrFetch isReceiving] == TRUE)
    {
        [loading show];
    }
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildProfileUpdateRequest: (NSString*) token withUserName: (NSString*) username withImage: (NSString*) image withLocation: (NSString*) geolocation withBio: (NSString*) about
{
    NSMutableString* updateProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [updateProfile appendString:@"saveuserdata?"];
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&name=%@" , username];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&image=%@" , image];
    NSMutableString* parameter4 = [[NSMutableString alloc] initWithFormat: @"&location=%@" , geolocation];
    NSMutableString* parameter5 = [[NSMutableString alloc] initWithFormat: @"&bio=%@" , about];
    
    [updateProfile appendString:parameter1];
    [updateProfile appendString:parameter2];
    [updateProfile appendString:parameter3];
    [updateProfile appendString:parameter4];
    [updateProfile appendString:parameter5];
    
    NSLog(@"REQUEST INFO:: Update Profile -- %@", updateProfile);
    
    return [updateProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildFetchRequest: (NSString*) token
{
    NSMutableString* fetchProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [fetchProfile appendString:@"getuserdata?"];
    
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    
    [fetchProfile appendString:parameter1];
    
    NSLog(@"REQUEST INFO:: Get User Data -- %@", fetchProfile);
    
    return [fetchProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImageJPEGRepresentation(image, 0.0) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
