//
//  CameraController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlay.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CameraController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property(nonatomic, strong) UIImagePickerController *cameraUI;
@property(nonatomic, strong) CameraOverlay *overlay;

@property(nonatomic, strong) UIImage *image1;
@property(nonatomic, strong) UIImage *image2;
@property(nonatomic, strong) UIImage *image3;
@property(nonatomic, strong) UIImage *image4;
@property(nonatomic, strong) UIImage *image5;

@property(nonatomic, strong) IBOutlet UIImageView *photoStrip;

@property(nonatomic, strong) IBOutlet UIButton *takeReel;
@property(nonatomic, strong) IBOutlet UIButton *sendReel;
@property(nonatomic, strong) IBOutlet UIButton *saveReel;

@property(nonatomic, strong) IBOutlet UIButton *deleteReel;

@property(nonatomic, strong) NSURL *moviePath;

@property(nonatomic, strong) NSMutableArray *images;

- (void)recordPressed;
- (void)recordFinished;

@end
