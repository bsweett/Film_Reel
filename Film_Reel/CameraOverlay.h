//
//  CameraOverlay.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-20.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class is used to define the custom view for the ImagePicker and Camera. It sends
//  notifications rather than controlling anything as the CameraController contians the delegate.
//
//  NOTE:: this class is identical to iPadOverlay other than the fact that it maps to a different
//  xib file. There is probably a better way to do this using only one View Controller that loads
//  a different xib file based on device.

#import <UIKit/UIKit.h>

@interface CameraOverlay : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int remainingCount;
}

#pragma mark IBOutlets for Overlay
@property (nonatomic, strong) IBOutlet UIImageView * takeReelImage;
@property (nonatomic, strong) IBOutlet UITextView  * countDownText;
@property (nonatomic, strong) IBOutlet UIButton    * cancelButton;
@property (nonatomic, strong) IBOutlet UIButton    * flipButtonFront;
@property (nonatomic, strong) IBOutlet UIButton    * flipButtonRear;
@property (nonatomic, strong) IBOutlet UIButton    * flashOnButton;
@property (nonatomic, strong) IBOutlet UIButton    * flashOffButton;

#pragma mark Timer
@property (nonatomic, strong) NSTimer     *timer;

@end
