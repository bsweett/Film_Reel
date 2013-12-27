//
//  ProfileController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  One of the four tab views. This view controller controls the profile. It handles the displaying
//  of the current users information and the updating of it to the server. Users can also logout from
//  this view if they are not editing.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Networking.h"
#import "User.h"
#import "AppDelegate.h"

@interface ProfileController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#pragma mark Defined Objects
@property (strong, nonatomic) Networking  * Update;
@property (strong, nonatomic) AppDelegate *shared;

#pragma mark IBOutlets and Alerts
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UITextView  *name;
@property (strong, nonatomic) IBOutlet UITextView  *email;
@property (strong, nonatomic) IBOutlet UITextView  *bio;
@property (strong, nonatomic) IBOutlet UITextView  *location;
@property (strong, nonatomic) IBOutlet UIBarButtonItem    *cancel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem    *edit;
@property (strong, nonatomic) IBOutlet UIButton    *imageButton;
@property (strong, nonatomic) IBOutlet UIImageView *displaypicture;
@property (strong, nonatomic) IBOutlet UITextView  *reelCount;
@property (strong, nonatomic) IBOutlet UIImageView *male;
@property (strong, nonatomic) IBOutlet UIImageView *female;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;
@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;
@property (strong, nonatomic) UIAlertView * loading;
@property (strong, nonatomic) UIAlertView * error;

#pragma mark Local Variables
@property NSInteger maleHighlighted;
@property NSInteger femaleHighlighted;
@property (strong,retain    ) NSString    * saveBio;
@property (strong,retain    ) NSString    * saveName;
@property (strong,retain    ) NSString    * saveLocation;
@property (strong,retain    ) UIImage     * savedImage;
@property (nonatomic        ) int         * popular;

///////////////////////////////////////////////////////////////////////////

#pragma mark Profile interaction handling
- (void) setPopStars: (NSMutableString*) popular;
- (void) prepareForUpdate;
- (void) resetViews;
- (void) saveValues;
- (NSString*) buildProfileUpdateRequest: (NSString*) token withLocation: (NSString*) geolocation
                                withBio: (NSString*) about withGender: (NSString*) gender
                               withPath: (NSString *) path;

#pragma mark Network Handlers
- (void) didGetNetworkError: (NSNotification*) notif;
- (void) didSucceedRequest: (NSNotification*) notif;

#pragma mark Action Handlers
- (IBAction) doEdit:(id)sender;
- (IBAction) doCancel:(id)sender;
- (IBAction) doImageTap:(id)sender;
- (void) femalePushed:(UIGestureRecognizer*) recognizer;
- (void) malePushed:(UIGestureRecognizer*) recognizer;

#pragma mark -
#pragma mark NOTE:: Also contains TextView Delegate
#pragma mark -

#pragma mark -
#pragma mark NOTE:: Also contains ImagePicker Delegate
#pragma mark -

@end
