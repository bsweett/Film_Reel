//
//  ProfileController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Networking.h"
#import "User.h"
#import "AppDelegate.h"

@interface ProfileController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

// These local view variables must be mapped to the User object sent from the server at login in
@property (strong, nonatomic) IBOutlet UITextView *name;
@property (strong, nonatomic) IBOutlet UITextView *email;
@property (strong, nonatomic) IBOutlet UITextView *bio;
@property (strong, nonatomic) IBOutlet UITextView *location;
@property (strong, nonatomic) IBOutlet UIButton *cancel;
@property (strong, nonatomic) IBOutlet UIButton *edit;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIImageView *displaypicture;

@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;

@property (strong, nonatomic) UIAlertView * loading;
@property (strong, nonatomic) UIAlertView* error;
@property (strong, nonatomic) Networking* Update;

@property (strong, nonatomic) User* userdata;

@property (strong,retain) NSString* saveBio;
@property (strong,retain) NSString* saveName;
@property (strong,retain) NSString* saveLocation;
@property (strong,retain) UIImage* savedImage;
@property (nonatomic) int* popular;

-(void) didGetNetworkError: (NSNotification*) notif;
-(void) didSucceedRequest: (NSNotification*) notif;

- (IBAction)doEdit:(id)sender;
- (IBAction)doCancel:(id)sender;
- (IBAction)doImageTap:(id)sender;

@end
