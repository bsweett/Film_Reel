//
//  CameraOverlay.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-20.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "CameraOverlay.h"

@interface CameraOverlay ()

@end

@implementation CameraOverlay

@synthesize takeReelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *btnImage = [UIImage imageNamed:@"takereelbutton.png"];
    [takeReelButton setImage:btnImage forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    NSLog(@"Hello I got called");
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:3];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *moviePath = [[info objectForKey: UIImagePickerControllerMediaURL] path];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
        UISaveVideoAtPathToSavedPhotosAlbum (
                                             moviePath, nil, nil, nil);
    }
    
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:nil];
}

@end
