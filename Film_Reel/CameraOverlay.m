//
//  CameraOverlay.m
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

#import "CameraOverlay.h"

@interface CameraOverlay ()

@end

@implementation CameraOverlay

@synthesize takeReelImage;
@synthesize countDownText;
@synthesize timer;
@synthesize cancelButton;
@synthesize flipButtonFront;
@synthesize flipButtonRear;
@synthesize flashOnButton;
@synthesize flashOffButton;

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View Lifecycle
#pragma mark -
///////////////////////////////////////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Levae empty otherwise will call bad acess on thread
    }
    return self;
}


/**
 * This method is called when the Camera Overlay is loaded for the first
 * time. It sets up the Gestures and which buttons are enabled on startup
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    flipButtonRear.hidden = YES;
    flipButtonFront.hidden = NO;
    flashOnButton.hidden = NO;
    flashOffButton.hidden = YES;
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [takeReelImage addGestureRecognizer:singleTap];
}


/**
 * Handles any memory warnings sent from the OS
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    LogDebug(@"Memory Warning");
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Gesture recognizers and Button Actions
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Single Tap Gesture controller for the Start recording image. Tapping on 
 * the image calls this method, which will disable all buttons, initialize a
 * timer and send the CAMERA_START Notification
 *
 * @param recognizer This is the gesture passed from the tap gesture in
 * viewDidLoad
 */
-(void)singleTapping:(UIGestureRecognizer *)recognizer
{
    takeReelImage.highlighted = TRUE;
    [takeReelImage removeGestureRecognizer:[takeReelImage.gestureRecognizers objectAtIndex:0]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    remainingCount = 10;
    cancelButton.hidden = TRUE;
    flipButtonFront.hidden = TRUE;
    flipButtonRear.hidden = TRUE;
    flashOnButton.hidden = TRUE;
    flashOffButton.hidden = TRUE;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_START object:nil];
}


/**
 * Handles pressing the cancel button. Sends the CAMERA_CLOSE Notification to the
 * Camera Controller
 *
 * @param sender The sender is this view controller
 */
-(IBAction)cancelButtonPushed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_CLOSE object:nil];
}


/**
 * Handles pressing the flipFront button. Sends the CAMERA_FLIP_FRONT Notification to the
 * Camera Controller and switchs which flip button can be seen/pushed
 *
 * @param sender The sender is this view controller
 */
-(IBAction)flipButtonFrontPushed:(id)sender
{
    flipButtonFront.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLIP_FRONT object:nil];
    flipButtonRear.hidden = NO;
}


/**
 * Handles pressing the flipRear button. Sends the CAMERA_FLIP_REAR Notification to the
 * Camera Controller and switchs which flip button can be seen/pushed
 *
 * @param sender The sender is this view controller
 */
-(IBAction)flipButtonRearPushed:(id)sender
{
    flipButtonRear.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLIP_REAR object:nil];
    flipButtonFront.hidden = NO;
}


/**
 * Handles pressing the flashOn button. Sends the CAMERA_FLASH_ON Notification to the
 * Camera Controller and switchs which flash button can be seen/pushed
 *
 * @param sender The sender is this view controller
 */
-(IBAction)flashButtonOnPushed:(id)sender
{
    flashOnButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLASH_ON object:nil];
    flashOffButton.hidden = NO;
}


/**
 * Handles pressing the flashOff button. Sends the CAMERA_FLASH_OFF Notification to the
 * Camera Controller and switchs which flash button can be seen/pushed
 *
 * @param sender The sender is this view controller
 */
-(IBAction)flashButtonOffPushed:(id)sender
{
    flashOffButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLASH_OFF object:nil];
    flashOnButton.hidden = NO;
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Count down
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Updates the counter and displays it on the screen. Sends the CAMERA_STOP Notification
 * to the Camera Controller
 *
 */
-(void)countDown
{
    [countDownText setText:[NSString stringWithFormat:@"%d", remainingCount]];
    [countDownText setTextColor:[UIColor redColor]];
    [countDownText setFont:[UIFont boldSystemFontOfSize:40.0]];
    [countDownText setTextAlignment:NSTextAlignmentCenter];
    
    if (--remainingCount == -1)
    {
        [timer invalidate];
        [countDownText setHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_STOP object:nil];
    }
}



@end

