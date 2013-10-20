//
//  CameraController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "CameraController.h"
#import "MobileCoreServices/UTCoreTypes.h"

@interface CameraController ()

@end

@implementation CameraController

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
   cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [cameraUI setVideoMaximumDuration:10];
    
    //[controller presentModalViewController: cameraUI animated: YES];
    [controller presentViewController:cameraUI animated:NO completion:nil];
    return YES;
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
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
