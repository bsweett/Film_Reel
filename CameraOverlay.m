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

@synthesize takeReelImage, countDownText, timer, cancelButton;

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
    NSLog(@"image click");
    takeReelImage.highlighted = TRUE;
    [takeReelImage removeGestureRecognizer:[takeReelImage.gestureRecognizers objectAtIndex:0]];
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    remainingCount = 10;
    cancelButton.hidden = TRUE;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startRecord" object:nil];
}

-(IBAction)cancelButtonPushed:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeCamera" object:nil];
}

-(void)countDown {
   
    [countDownText setText:[NSString stringWithFormat:@"%d", remainingCount]];
    [countDownText setTextColor:[UIColor redColor]];
    [countDownText setFont:[UIFont boldSystemFontOfSize:40.0]];
    [countDownText setTextAlignment:NSTextAlignmentCenter];
    
    if (--remainingCount == -1) {
        [timer invalidate];
        [countDownText setHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopRecord" object:nil];
    }
}



@end

