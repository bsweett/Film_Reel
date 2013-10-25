//
//  CameraController.m
//  Film_Reel
//
//  Created by Brayden Girard on 2013-10-19.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "CameraController.h"
#import "MobileCoreServices/UTCoreTypes.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>
#import <CoreMedia/CMTimeRange.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface CameraController ()

@end

@implementation CameraController

@synthesize cameraUI, overlay, moviePath, image1, image2, image3, image4, image5, photoStrip, finalImage, originalImage, iPadoverlay;

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
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if(finalImage != NULL)
    {
        [library saveImage:finalImage toAlbum:@"My Reels" withCompletionBlock: ^(NSError *error){
            if (error != nil) {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"IMAGE SAVE FAILED"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            } else {
                UIAlertView *myal = [[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [myal show];
                [self performSelector:@selector(test:) withObject:myal afterDelay:2];
            }
        }];
    } else
    {
        UIAlertView *myal = [[UIAlertView alloc] initWithTitle:@"No Reel" message:@"No Reel has be taken" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [myal show];
        [self performSelector:@selector(test:) withObject:myal afterDelay:2];
    }
    
}

-(void)test:(UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}

-(IBAction)deleteReel:(id)sender {
    photoStrip.image = nil;
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
    
    // Check Device to load specific view
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
       iPadoverlay = [[iPadOverlay alloc] initWithNibName:@"iPadOverlay" bundle:nil];
        cameraUI.cameraOverlayView = iPadoverlay.view;
    } else {
        overlay = [[CameraOverlay alloc] initWithNibName:@"CameraOverlay" bundle:nil];
        cameraUI.cameraOverlayView = overlay.view;
    }
    
    
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
    image1 = [[UIImage alloc] initWithCGImage:ref1];
    
    CMTime time2 = CMTimeMake(3, 1);
    CGImageRef ref2 = [generate1 copyCGImageAtTime:time2 actualTime:NULL error:&err];
    image2 = [[UIImage alloc] initWithCGImage:ref2];
  
    
    CMTime time3 = CMTimeMake(5, 1);
    CGImageRef ref3 = [generate1 copyCGImageAtTime:time3 actualTime:NULL error:&err];
    image3 = [[UIImage alloc] initWithCGImage:ref3];
   
    
    CMTime time4 = CMTimeMake(7, 1);
    CGImageRef ref4 = [generate1 copyCGImageAtTime:time4 actualTime:NULL error:&err];
    image4 = [[UIImage alloc] initWithCGImage:ref4];
    
    
    CMTime time5 = CMTimeMake(9, 1);
    CGImageRef ref5 = [generate1 copyCGImageAtTime:time5 actualTime:NULL error:&err];
    image5 = [[UIImage alloc] initWithCGImage:ref5];
   
    originalImage = [self mergeImage:image1 withImage:image2 andImage:image3 andImage:image4 andImage:image5];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGSize imgSize = originalImage.size;
    
    float ratio = (screenWidth/2)/imgSize.width;
    float scaledHeight=imgSize.height*ratio;
    
    photoStrip.frame = CGRectMake(0, 0, screenWidth/2, scaledHeight);
        //photoStrip.center = photoStrip.superview.center;
    
    finalImage = [self imageWithImage:originalImage convertToSize:photoStrip.frame.size];
    
    [photoStrip setImage:finalImage];
   // photoStrip.contentMode = UIViewContentModeScaleAspectFit;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth/4,44, screenWidth/2,900)];
    
    [scrollView setContentSize:CGSizeMake(screenWidth/2,scaledHeight + 425)];
    
    
    [scrollView addSubview:photoStrip];
    
    [self.view addSubview:scrollView];
    
    
    
}

- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second andImage:(UIImage*)third andImage:(UIImage*)fourth andImage:(UIImage*)fifth
{
    // get size of the first image
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    // get size of the second image
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    // get size of the first image
    CGImageRef thirdImageRef = third.CGImage;
    CGFloat thirdWidth = CGImageGetWidth(thirdImageRef);
    CGFloat thirdHeight = CGImageGetHeight(thirdImageRef);
    
    // get size of the second image
    CGImageRef fourthImageRef = fourth.CGImage;
    CGFloat fourthWidth = CGImageGetWidth(fourthImageRef);
    CGFloat fourthHeight = CGImageGetHeight(fourthImageRef);
    
    // get size of the first image
    CGImageRef fifthImageRef = fifth.CGImage;
    CGFloat fifthWidth = CGImageGetWidth(fifthImageRef);
    CGFloat fifthHeight = CGImageGetHeight(fifthImageRef);
    
    // build merged size 
    CGSize mergedSize = CGSizeMake(firstWidth, firstHeight + secondHeight + thirdHeight + fourthHeight + fifthHeight);
    
    // capture image context ref
    UIGraphicsBeginImageContext(mergedSize);
    
     //Draw images onto the context
    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [second drawInRect:CGRectMake(0, firstHeight, secondWidth, secondHeight)];
    [third drawInRect:CGRectMake(0, firstHeight + secondHeight, thirdWidth, thirdHeight)];
    [fourth drawInRect:CGRectMake(0, firstHeight + secondHeight + thirdHeight, fourthWidth, fourthHeight)];
    [fifth drawInRect:CGRectMake(0, firstHeight + secondHeight + thirdHeight + fourthHeight, fifthWidth, fifthHeight)];
    
    // assign context to new UIImage
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end context
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

- (void) recordPressed {
    NSLog(@"lets record");
    [self.cameraUI startVideoCapture];
}

-(void) recordFinished {
    NSLog(@"recording done");
    [self.cameraUI stopVideoCapture];
}

-(void) closeCamera {
    NSLog(@"close camera");
    
    [cameraUI dismissViewControllerAnimated:NO completion:nil];
    
}

@end