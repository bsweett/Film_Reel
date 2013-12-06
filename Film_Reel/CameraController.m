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

@synthesize image1, image2, image3, image4, image5, combinedImage, stripImage, frameImage;
@synthesize takeReel, saveReel;
@synthesize cameraUI, cameraOverlay, iPadoverlay;
@synthesize moviePath;
@synthesize photoStrip;
@synthesize sendReelRequest;
@synthesize alert;

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
    
    // Camera Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordPressed) name:@CAMERA_START object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recordFinished) name:@CAMERA_STOP object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeCamera) name:@CAMERA_CLOSE object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    // Set up Gestures
    UISwipeGestureRecognizer * recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [recognizerLeft setDelegate:self];
    [self.view addGestureRecognizer:recognizerLeft];
    [recognizerLeft setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    

    UISwipeGestureRecognizer * recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [recognizerRight setDelegate:self];
    [self.view addGestureRecognizer:recognizerRight];
    [recognizerRight setDirection:(UISwipeGestureRecognizerDirectionRight)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

// Sends reel
-(IBAction)takeReelPressed:(id)sender
{
   [self startCameraControllerFromViewController: self usingDelegate: self];
}

-(void) handleSwipeRight:(UITapGestureRecognizer *)recognizer
{
    NSLog(@"Swipe Left");
    [self startCameraControllerFromViewController: self usingDelegate: self];
}

-(void) handleSwipeLeft:(UITapGestureRecognizer *)recognizer
{
     NSLog(@"Swipe Right");

    if(frameImage != NULL)
    {
        [self performSegueWithIdentifier:@"send" sender:self];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@REEL_MISSING_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:2];
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass image as text
    NSData *imageAsData = UIImageJPEGRepresentation(frameImage, 1.0f);
    SelectFriendController* destViewController = segue.destinationViewController;
    destViewController.imageToSend = imageAsData;
}

// Saves Reel to local photo album
-(IBAction)saveReelPressed:(id)sender {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    if(frameImage != NULL)
    {
        [library saveImage:frameImage toAlbum:@"My Reels" withCompletionBlock: ^(NSError *error){
            if (error != nil) {
                alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:[NSString stringWithFormat:@"IMAGE SAVE FAILED"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            } else {
                alert = [[UIAlertView alloc] initWithTitle:@"Success" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:2];
            }
        }];
    } else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@REEL_MISSING_ERROR delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [self performSelector:@selector(dismissErrors:) withObject:alert afterDelay:2];
    }
    
}

-(void)dismissErrors: (UIAlertView*)x{
	[x dismissWithClickedButtonIndex:-1 animated:YES];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller usingDelegate: (id <UIImagePickerControllerDelegate,UINavigationControllerDelegate>) delegate {
    
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
        cameraOverlay = [[CameraOverlay alloc] initWithNibName:@"CameraOverlay" bundle:nil];
        cameraUI.cameraOverlayView = cameraOverlay.view;
    }
    
    [controller presentViewController:cameraUI animated:NO completion:nil];
    
    return YES;
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    moviePath = [info objectForKey:UIImagePickerControllerMediaURL];
    
    [[picker parentViewController] dismissViewControllerAnimated:NO completion:nil];
    
    [self convertVideo];
    
    [cameraUI dismissViewControllerAnimated:NO completion:nil];

    
}

// Takes the video and converts it to a film strip
-(void)convertVideo
{
    [self getMovieClips];
    
    stripImage = [self mergeImage:image1 withImage:image2 andImage:image3 andImage:image4 andImage:image5];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGSize imgSize = stripImage.size;
    
    float ratio = (screenWidth/2)/imgSize.width;
    float scaledHeight=imgSize.height*ratio;
    
    photoStrip.frame = CGRectMake(0, 0, screenWidth/2, scaledHeight);
    
    combinedImage = [self imageWithImage:stripImage convertToSize:photoStrip.frame.size];
    frameImage = [self addBorder:combinedImage];
    
    [photoStrip setImage:frameImage];
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth/4,74, screenWidth/2,865)];
        [scrollView setShowsVerticalScrollIndicator:FALSE];
        [scrollView setContentSize:CGSizeMake(screenWidth/2,scaledHeight)];
        [scrollView addSubview:photoStrip];
        [self.view addSubview:scrollView];
    } else {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(screenWidth/4,74, screenWidth/2,415)];
        [scrollView setShowsVerticalScrollIndicator:FALSE];
        [scrollView setContentSize:CGSizeMake(screenWidth/2,scaledHeight)];
        [scrollView addSubview:photoStrip];
        [self.view addSubview:scrollView];
    }
}

// Clips five image from the video
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
}

// Merges the five images together into one "film strip" image
- (UIImage*)mergeImage:(UIImage*)first withImage:(UIImage*)second andImage:(UIImage*)third andImage:(UIImage*)fourth andImage:(UIImage*)fifth
{
    CGImageRef firstImageRef = first.CGImage;
    CGFloat firstWidth = CGImageGetWidth(firstImageRef);
    CGFloat firstHeight = CGImageGetHeight(firstImageRef);
    
    CGImageRef secondImageRef = second.CGImage;
    CGFloat secondWidth = CGImageGetWidth(secondImageRef);
    CGFloat secondHeight = CGImageGetHeight(secondImageRef);
    
    CGImageRef thirdImageRef = third.CGImage;
    CGFloat thirdWidth = CGImageGetWidth(thirdImageRef);
    CGFloat thirdHeight = CGImageGetHeight(thirdImageRef);
    
    CGImageRef fourthImageRef = fourth.CGImage;
    CGFloat fourthWidth = CGImageGetWidth(fourthImageRef);
    CGFloat fourthHeight = CGImageGetHeight(fourthImageRef);
    
    CGImageRef fifthImageRef = fifth.CGImage;
    CGFloat fifthWidth = CGImageGetWidth(fifthImageRef);
    CGFloat fifthHeight = CGImageGetHeight(fifthImageRef);
    
    CGSize mergedSize = CGSizeMake(firstWidth, firstHeight + secondHeight + thirdHeight + fourthHeight + fifthHeight);
    
    UIGraphicsBeginImageContext(mergedSize);

    [first drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
    [second drawInRect:CGRectMake(0, firstHeight, secondWidth, secondHeight)];
    [third drawInRect:CGRectMake(0, firstHeight + secondHeight, thirdWidth, thirdHeight)];
    [fourth drawInRect:CGRectMake(0, firstHeight + secondHeight + thirdHeight, fourthWidth, fourthHeight)];
    [fifth drawInRect:CGRectMake(0, firstHeight + secondHeight + thirdHeight + fourthHeight, fifthWidth, fifthHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

// Converts the size of the image to fit the display
- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

// Adds a border line between the images
- (UIImage*)addBorder:(UIImage*)image
{
    
    UIImage *seperator = [UIImage imageNamed:@"seperator.png"];

    
    CGImageRef imageRef = image.CGImage;
    CGFloat firstWidth = CGImageGetWidth(imageRef);
    CGFloat firstHeight = CGImageGetHeight(imageRef);
    
    CGSize mergedSize = CGSizeMake(firstWidth, firstHeight + 20);
    
    UIGraphicsBeginImageContext(mergedSize);
    
    CGFloat heightSep = (firstHeight/5);
    
    if([[UIDevice currentDevice].model isEqualToString:@"iPad"])
    {
        [image drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
        [seperator drawInRect:CGRectMake(0,heightSep - 7, 385, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*2) - 7, 385, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*3) - 7, 385, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*4) - 7, 385, 10)];
    }
    else
    {
        [image drawInRect:CGRectMake(0, 0, firstWidth, firstHeight)];
        [seperator drawInRect:CGRectMake(0,heightSep - 7, 320, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*2) - 7, 320, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*3) - 7, 320, 10)];
        [seperator drawInRect:CGRectMake(0,(heightSep*4) - 7, 320, 10)];
    }
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

// When the record button is pressed
// Start the video and timer
- (void) recordPressed {
    [self.cameraUI startVideoCapture];
}

// After a 10 second timer expires
// Stop the video from recording
-(void) recordFinished {
    [self.cameraUI stopVideoCapture];
}

// When the cancel button on the camera is pressed
// Close the camera view
-(void) closeCamera {
    [cameraUI dismissViewControllerAnimated:NO completion:nil];
}

@end