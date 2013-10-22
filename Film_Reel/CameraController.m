//
//  CameraController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "CameraController.h"
#import "MobileCoreServices/UTCoreTypes.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CMTimeRange.h>

@interface CameraController ()

@end

@implementation CameraController

@synthesize cameraUI, overlay, moviePath, images, image1, image2, image3, image4, image5;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordPressed) name:@"startRecord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinished) name:@"stopRecord" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCamera) name:@"closeCamera" object:nil];
    
    images = [[NSMutableArray alloc]init];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processImage:) name:@"MPMoviePlayerThumbnailImageRequestDidFinishNotification" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takeReelPressed:(id)sender {
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

-(IBAction)sendReelPressed:(id)sender {
    
}

-(IBAction)saveReel:(id)sender {
    
}

-(IBAction)deleteReel:(id)sender {
    
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    
    cameraUI.allowsEditing = NO;
    cameraUI.showsCameraControls = NO;
    cameraUI.navigationBarHidden = YES;
    cameraUI.toolbarHidden = YES;
    
    cameraUI.delegate = self;
    
    overlay = [[CameraOverlay alloc] initWithNibName:@"CameraOverlay" bundle:nil];
    cameraUI.cameraOverlayView = overlay.view;
    //[cameraUI setDelegate:overlay];
    
    [controller presentViewController:cameraUI animated:NO completion:nil];
    
    return YES;
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    moviePath = [info objectForKey:UIImagePickerControllerMediaURL];
    
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:nil];
    
    [self getMovieClips];
    
    [cameraUI dismissViewControllerAnimated:NO completion:nil];

    
}

-(void)getMovieClips
{
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:moviePath options:nil];
    AVAssetImageGenerator *generate1 = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generate1.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    
    CMTime time1 = CMTimeMake(1, 1);
    CGImageRef ref1 = [generate1 copyCGImageAtTime:time1 actualTime:NULL error:&err];
    [image1 setImage:[[UIImage alloc] initWithCGImage:ref1]];
    image1.contentMode = UIViewContentModeScaleAspectFit;
    
    CMTime time2 = CMTimeMake(3, 1);
    CGImageRef ref2 = [generate1 copyCGImageAtTime:time2 actualTime:NULL error:&err];
    [image2 setImage:[[UIImage alloc] initWithCGImage:ref2]];
    image2.contentMode = UIViewContentModeScaleAspectFit;
    
    CMTime time3 = CMTimeMake(5, 1);
    CGImageRef ref3 = [generate1 copyCGImageAtTime:time3 actualTime:NULL error:&err];
    [image3 setImage:[[UIImage alloc] initWithCGImage:ref3]];
    image3.contentMode = UIViewContentModeScaleAspectFit;
    
    CMTime time4 = CMTimeMake(7, 1);
    CGImageRef ref4 = [generate1 copyCGImageAtTime:time4 actualTime:NULL error:&err];
    [image4 setImage:[[UIImage alloc] initWithCGImage:ref4]];
    image4.contentMode = UIViewContentModeScaleAspectFit;
    
    CMTime time5 = CMTimeMake(9, 1);
    CGImageRef ref5 = [generate1 copyCGImageAtTime:time5 actualTime:NULL error:&err];
    [image5 setImage:[[UIImage alloc] initWithCGImage:ref5]];
    image5.contentMode = UIViewContentModeScaleAspectFit;
   
    
}

- (void) recordPressed {
    NSLog(@"lets record");
    [self.cameraUI startVideoCapture];
}

-(void) recordFinished {
    NSLog(@"recording done");
    [self.cameraUI stopVideoCapture];
    //[cameraUI dismissViewControllerAnimated:NO completion:nil];
}

-(void) closeCamera {
    NSLog(@"close camera");
    
    [cameraUI dismissViewControllerAnimated:NO completion:nil];
    
}

@end