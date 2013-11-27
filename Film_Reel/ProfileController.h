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

@property (strong, retain) IBOutlet UITextView* name;
@property (strong, retain) IBOutlet UITextView* email;
@property (strong, retain) IBOutlet UITextView* bio;
@property (strong, retain) IBOutlet UITextView* location;
@property (strong, retain) IBOutlet UIButton *edit;
@property (strong, retain) IBOutlet UIButton *cancel;
@property (strong, retain) IBOutlet UIButton *imageButton;
@property (strong, retain) IBOutlet UIImageView * displaypicture;

@property (strong, nonatomic) UIAlertView * loading;
@property (strong, nonatomic) UIAlertView* error;
@property (strong, nonatomic) Networking* updateOrFetch;

@property (strong, nonatomic) NSString* currentUsersToken;
@property (strong, nonatomic) User* userdata;

@property (strong,retain) NSString* saveBio;
@property (strong,retain) NSString* saveName;
@property (strong,retain) NSString* saveLocation;
@property (strong,retain) UIImage* savedImage;
@property (nonatomic) int* popular;

-(void) didGetNetworkError: (NSNotification*) notif;
-(void) didSucceedRequest: (NSNotification*) notif;

@end
