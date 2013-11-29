//
//  CameraController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlay.h"
#import "iPadOverlay.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CameraController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIImagePickerController *cameraUI;
@property CameraOverlay *cameraOverlay;
@property iPadOverlay* iPadoverlay;

@property(nonatomic, strong) UIImage *image1;
@property(nonatomic, strong) UIImage *image2;
@property(nonatomic, strong) UIImage *image3;
@property(nonatomic, strong) UIImage *image4;
@property(nonatomic, strong) UIImage *image5;
@property(nonatomic, strong) UIImage *stripImage;
@property(nonatomic, strong) UIImage *combinedImage;
@property(nonatomic, strong) UIImage *frameImage;

@property(nonatomic, strong) IBOutlet UIImageView *photoStrip;

@property(nonatomic, strong) IBOutlet UIBarButtonItem *takeReel;

@property(nonatomic, strong) IBOutlet UIBarButtonItem *saveReel;

@property(nonatomic, strong) NSURL *moviePath;

@property(nonatomic, strong) Networking *sendReelRequest;
@property(nonatomic, strong) UIAlertView *alert;

- (IBAction)takeReelPressed:(id)sender;
- (IBAction)saveReelPressed:(id)sender;
- (void)handleSwipeRight:(UITapGestureRecognizer *)recognizer;
- (void)handleSwipeLeft:(UITapGestureRecognizer *)recognizer;
- (void)recordPressed;
- (void)recordFinished;

@end
