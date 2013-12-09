//
//  CameraController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class is the view controller for the camera view. It is the starting view once a user
//  logs in. This class handles the control for the ImagePicker and Camera. It has actions for
//  saving Reels, starting the camera, and opening the list of users a reel can be sent too.
//

#import <UIKit/UIKit.h>
#import "CameraOverlay.h"
#import "iPadOverlay.h"
#import "SelectFriendController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MobileCoreServices/UTCoreTypes.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CMTimeRange.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate>

#pragma mark Defined Object
@property (nonatomic, strong) CameraOverlay           * cameraOverlay;
@property (nonatomic, strong) iPadOverlay             * iPadoverlay;
@property (nonatomic, strong) Networking              * sendReelRequest;

#pragma mark Image Picker
@property (nonatomic, strong) UIImagePickerController * cameraUI;

#pragma mark Images and Media for modifying
@property (nonatomic, strong) UIImage                 * image1;
@property (nonatomic, strong) UIImage                 * image2;
@property (nonatomic, strong) UIImage                 * image3;
@property (nonatomic, strong) UIImage                 * image4;
@property (nonatomic, strong) UIImage                 * image5;
@property (nonatomic, strong) UIImage                 * stripImage;
@property (nonatomic, strong) UIImage                 * combinedImage;
@property (nonatomic, strong) UIImage                 * frameImage;
@property (nonatomic, strong) NSURL                   * moviePath;

#pragma mark IBOutlets and alerts
@property (nonatomic, strong) IBOutlet UIImageView             * photoStrip;
@property (nonatomic, strong) IBOutlet UIBarButtonItem         * takeReel;
@property (nonatomic, strong) IBOutlet UIBarButtonItem         * saveReel;
@property (nonatomic, strong)          UIAlertView             * alert;

#pragma mark Other Variables
@property (nonatomic) BOOL flashOkForFront;
@property (nonatomic) BOOL flashOkForRear;

///////////////////////////////////////////////////////////////////////////

#pragma mark Button and Gesture Actions
- (IBAction) takeReelPressed:(id)sender;
- (IBAction) saveReelPressed:(id)sender;
- (void) handleSwipeRight:(UITapGestureRecognizer *)recognizer;
- (void) handleSwipeLeft:(UITapGestureRecognizer *)recognizer;

#pragma mark Image and video converison
- (void) convertVideo;
- (void) getMovieClips;
- (UIImage*) mergeImage:(UIImage*)first withImage:(UIImage*)second andImage:(UIImage*)third
                                        andImage:(UIImage*)fourth andImage:(UIImage*)fifth;
- (UIImage*) imageWithImage:(UIImage *)image convertToSize:(CGSize)size;
- (UIImage*) addBorder:(UIImage*)image;

#pragma mark Camera Overlay notification handlers
- (void) recordPressed;
- (void) recordFinished;
- (void) closeCamera;
- (void) flipCamera: (NSNotification*) notif;
- (void) flashChanged: (NSNotification*) notif;

@end
