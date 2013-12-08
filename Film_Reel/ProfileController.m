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

@synthesize userdata;
    
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *maleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(malePushed:)];
    [maleTap setNumberOfTapsRequired:1];
    [male addGestureRecognizer:maleTap];
    
    UITapGestureRecognizer *femaleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(femalePushed:)];
    [femaleTap setNumberOfTapsRequired:1];
    [female addGestureRecognizer:femaleTap];
    
    bio.editable = NO;
    name.editable = NO;
    location.editable = NO;
    email.editable = NO;
    
   
    [[navigationItem leftBarButtonItem]setTitle:@"Logout"];
    
    imageButton.enabled = NO;
    imageButton.hidden = YES;
    male.userInteractionEnabled = NO;
    female.userInteractionEnabled = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@ADDRESS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didGetNetworkError:) name:@FAIL_STATUS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSucceedRequest:) name:@RESPONSE_FOR_POST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@UPDATE_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSucceedRequest:) name:@USER_NOT_FOUND object:nil];
    
    
    bio.delegate = self;
    name.delegate = self;
    location.delegate = self;
    email.delegate = self;
    reelCount.delegate = self;
    
    shared = [AppDelegate appDelegate];
    userdata = shared.appUser;
    
    Update = [[Networking alloc] init];
    
    [[self bio] setText: userdata.getUserBio];
    [[self name] setText: userdata.getUserName];
    [[self location] setText:userdata.getLocation];
    [[self email] setText: userdata.getEmail];
    NSLog(@"The reel count is: %@", [shared.appUser getReelCount]);
    [[self reelCount] setText:[userdata getReelCount]];
    
    if([[shared.appUser getGender] isEqualToString:@"M"]) {
        male.highlighted = TRUE;
    }
    if([[shared.appUser getGender] isEqualToString:@"F"]) {
        female.highlighted = TRUE;
    }
    if([[shared.appUser getGender] isEqualToString:@"U"]) {
        female.highlighted = FALSE;
        male.highlighted = FALSE;
    }
    
    // Reformat all text
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        [[self name] setFont:[UIFont systemFontOfSize:32]];
        [[self bio] setFont:[UIFont systemFontOfSize:20]];
        [[self location] setFont:[UIFont systemFontOfSize:20]];
        [[self email] setFont:[UIFont systemFontOfSize:22]];
    }
    else
    {
        [[self name] setFont:[UIFont systemFontOfSize:30]];
        name.textAlignment = NSTextAlignmentCenter;
        [[self name] setTextColor:[UIColor blackColor]];
        [[self bio] setFont:[UIFont systemFontOfSize:12]];
        [[self bio] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1]];
        [[self location] setFont:[UIFont systemFontOfSize:12]];
        [[self location] setTextColor:[[UIColor alloc] initWithRed:92.0/255.0 green:92.0/255.0 blue:92.0/255.0 alpha:1]];
        [[self email] setFont:[UIFont systemFontOfSize:12]];
        email.textAlignment = NSTextAlignmentCenter;
        [[self email] setTextColor:[UIColor blackColor]];
    }
    
    [self setPopStars:userdata.getPopularity];
}

-(void)viewDidAppear:(BOOL)animated
{
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)malePushed:(UIGestureRecognizer*) recognizer {
    NSLog(@"pushed male");
    if(male.highlighted == FALSE)
    {
        male.highlighted = TRUE;
        female.highlighted = FALSE;
        userdata.gender = [NSMutableString stringWithFormat:@"M"];
    }
}

- (void)femalePushed:(UIGestureRecognizer*) recognizer {
    NSLog(@"pushed femail");
    if(female.highlighted == FALSE)
    {
        female.highlighted = TRUE;
        male.highlighted = FALSE;
        userdata.gender = [NSMutableString stringWithFormat:@"F"];
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
    
    if([[notif name] isEqualToString:@RESPONSE_FOR_POST])
    {
        NSDictionary* userDictionary = [notif userInfo];
        NSString* response= [userDictionary valueForKey:@POST_RESPONSE];
        
        if([response isEqualToString:@""])
        {
            [self prepareForUpdate];
        }
        else
        {
            NSLog(@"SERVER ERROR:: Could not upload profile picture");
        }
    }
    
    if([[notif name] isEqualToString:@UPDATE_SUCCESS])
    {
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
        [Update saveImageToServer:UIImageJPEGRepresentation(displaypicture.image, 0.1f) withFileName:[userdata getEmail]];
        
        
        [self prepareForUpdate];
 
    }
}

-(IBAction)doCancel:(id)sender
{
    if([[[navigationItem leftBarButtonItem]title] isEqualToString:@"Cancel"])
    {
        [[navigationItem rightBarButtonItem] setTitle:@"Edit"];
        [[navigationItem leftBarButtonItem]setTitle:@"Logout"];
        bio.editable = NO;
        location.editable = NO;
        [[navigationItem leftBarButtonItem]setTitle:nil];
        [[navigationItem leftBarButtonItem]setEnabled:FALSE];
        imageButton.enabled = NO;
        imageButton.hidden = YES;
        male.userInteractionEnabled = NO;
        female.userInteractionEnabled = NO;
        
        // undo changes
        [self resetViews];
    }
    else {
        NSLog(@"Logout pushed");
        [shared.appUser setToken:nil];
        [self.presentingViewController dismissViewControllerAnimated: YES completion:nil];
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
    savedImage = displaypicture.image;
    
    if(male.highlighted == TRUE) {
        maleHighlighted = 1;
    }
    if(female.highlighted == TRUE) {
        femaleHighlighted = 1;
    }
    if(female.highlighted == FALSE && male.highlighted == FALSE) {
        femaleHighlighted = 0;
        maleHighlighted = 0;
    }

    
}

// reset the local values when they hit cancel
-(void) resetViews
{
    [[self bio] setText: saveBio];
    [[self location] setText:saveLocation];
    [[self displaypicture] setImage: savedImage];
    
    if(maleHighlighted == 1) {
        male.highlighted = TRUE;
        female.Highlighted = FALSE;
    }
    if(femaleHighlighted == 1) {
        female.highlighted = TRUE;
        male.highlighted = FALSE;
    }
    if(femaleHighlighted == 0 && maleHighlighted == 0) {
        male.highlighted = FALSE;
        female.highlighted = FALSE;
    }

}

// get ready to pass the update to the server
-(void) prepareForUpdate
{
    loading = [[UIAlertView alloc] initWithTitle:nil message:@"Updating" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    NSString* updatedLocation = location.text;
    NSString* updatedBio = bio.text;
    NSString* updatedGender;
    
    if(male.highlighted == TRUE) {
        updatedGender = @"M";
    }
    if(female.highlighted == TRUE) {
        updatedGender = @"F";
    }
    if(female.highlighted == FALSE && male.highlighted == FALSE) {
        updatedGender = @"U";
    }
    
    [shared.appUser setLocation:[NSMutableString stringWithString:updatedLocation]];
    [shared.appUser setUserBio:[NSMutableString stringWithString:updatedBio]];
    [shared.appUser setGender: [NSMutableString stringWithString:updatedGender]];

    NSString* request = [self buildProfileUpdateRequest:[userdata getToken] withLocation:updatedLocation withBio:updatedBio withGender:updatedGender withPath:userdata.getEmail];
    
    [Update startReceive:request withType:@UPDATE_REQUEST];
    
    if ([Update isReceiving] == TRUE)
    {
        [loading show];
    }
}

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

// ????? Why are we sending images to through struts request ?

// This is the template for building future URLRequests
// NOTE:: SERVER_ADDRESS is hardcoded in Networking.h
- (NSString*) buildProfileUpdateRequest: (NSString*) token withLocation: (NSString*) geolocation withBio: (NSString*) about withGender: (NSString*) gender withPath: (NSString *) path
{
    NSMutableString* updateProfile = [[NSMutableString alloc] initWithString:@SERVER_ADDRESS];
    [updateProfile appendString:@"saveuserdata?"];
    NSMutableString* parameter1 = [[NSMutableString alloc] initWithFormat: @"token=%@" , token];
    NSMutableString* parameter2 = [[NSMutableString alloc] initWithFormat: @"&location=%@" , geolocation];
    NSMutableString* parameter3 = [[NSMutableString alloc] initWithFormat: @"&bio=%@" , about];
    NSMutableString* parameter4 = [[NSMutableString alloc] initWithFormat: @"&gender=%@", gender];
    NSMutableString* parameter5 = [[NSMutableString alloc] initWithFormat: @"&path=%@", gender];
    
    [updateProfile appendString:parameter1];
    [updateProfile appendString:parameter2];
    [updateProfile appendString:parameter3];
    [updateProfile appendString:parameter4];
    [updateProfile appendString:parameter5];
    
    NSLog(@"REQUEST INFO:: Update Profile -- %@", updateProfile);
    
    return [updateProfile stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

@end
