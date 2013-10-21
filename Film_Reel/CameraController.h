//
//  CameraController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CameraOverlay.h"

@interface CameraController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property(nonatomic, strong) UIImagePickerController *cameraUI;
@property(nonatomic, strong) CameraOverlay *overlay;

@end
