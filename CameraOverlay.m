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

@synthesize takeReelImage, countDownText, timer;

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
    
    UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapping:)];
    [singleTap setNumberOfTapsRequired:1];
    [takeReelImage addGestureRecognizer:singleTap];
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
    

}

-(void)countDown {
   
    [countDownText setText:[NSString stringWithFormat:@"%d", remainingCount]];
    [countDownText setTextColor:[UIColor redColor]];
    [countDownText setFont:[UIFont boldSystemFontOfSize:40.0]];
    [countDownText setTextAlignment:NSTextAlignmentCenter];
    
    if (--remainingCount == -1) {
        [timer invalidate];
        [countDownText setHidden:TRUE];
    }
    
}

@end
