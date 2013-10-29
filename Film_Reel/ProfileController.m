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
	// Do any additional setup after loading the view.
    
    // Get current logged in instance of the user
    // Wont Save State of the application need to post to server on update and pull down on view didload
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        [self prepareForUpdate];
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

// Allow them to pic an image for their profile
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
    /*
    NSString* updatedName = name.text;
    NSString* updatedLocation = location.text;
    NSString* updatedBio = bio.text;
    UIImage* updatedPic = displaypicture.image;
    */
}

@end
