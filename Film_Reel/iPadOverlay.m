//
//  iPadOverlay.m
//  Film_Reel
//
//  Created by Ben Sweett on 10/24/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "iPadOverlay.h"

@interface iPadOverlay ()

@end

@implementation iPadOverlay

@synthesize takeReelImage;
@synthesize countDownText;
@synthesize timer;
@synthesize cancelButton;
@synthesize flipButtonFront;
@synthesize flipButtonRear;
@synthesize flashOnButton;
@synthesize flashOffButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Levae empty otherwise will call bad acess on thread
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    flipButtonRear.hidden = YES;
    flipButtonFront.hidden = NO;
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [takeReelImage addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_START object:nil];
}

-(IBAction)cancelButtonPushed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_CLOSE object:nil];
}

-(IBAction)flipButtonFrontPushed:(id)sender
{
    flipButtonFront.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLIP_FRONT object:nil];
    flipButtonRear.hidden = NO;
}

-(IBAction)flipButtonRearPushed:(id)sender
{
    flipButtonRear.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLIP_REAR object:nil];
    flipButtonFront.hidden = NO;
}

-(IBAction)flashButtonOnPushed:(id)sender
{
    flashOnButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLASH_ON object:nil];
    flashOffButton.hidden = NO;
}

-(IBAction)flashButtonOffPushed:(id)sender
{
    flashOffButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_FLASH_OFF object:nil];
    flashOnButton.hidden = NO;
}

-(void)countDown {
    
    [countDownText setText:[NSString stringWithFormat:@"%d", remainingCount]];
    [countDownText setTextColor:[UIColor redColor]];
    [countDownText setFont:[UIFont boldSystemFontOfSize:40.0]];
    [countDownText setTextAlignment:NSTextAlignmentCenter];
    
    if (--remainingCount == -1) {
        [timer invalidate];
        [countDownText setHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:@CAMERA_STOP object:nil];
    }
    
}



@end


