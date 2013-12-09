//
//  CameraOverlay.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-20.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraOverlay : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int remainingCount;
}

@property (nonatomic, strong) IBOutlet UIImageView * takeReelImage;
@property (nonatomic, strong) IBOutlet UITextView  * countDownText;
@property (nonatomic, strong) IBOutlet UIButton    * cancelButton;
@property (nonatomic, strong) IBOutlet UIButton    * flipButtonFront;
@property (nonatomic, strong) IBOutlet UIButton    * flipButtonRear;
@property (nonatomic, strong) IBOutlet UIButton    * flashOnButton;
@property (nonatomic, strong) IBOutlet UIButton    * flashOffButton;
@property (nonatomic, strong) NSTimer     *timer;

@end
