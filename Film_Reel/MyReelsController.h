//
//  MyReelsController.h
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface MyReelsController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, retain) UIImagePickerController *imagePicker;
@property (strong, retain) NSMutableArray* assets;
@property (strong, nonatomic) NSMutableArray* urlStoreArr;
@property (strong, nonatomic) ALAssetsLibrary * library;
@property(nonatomic, strong) IBOutlet UIImageView *imageview;

@end
