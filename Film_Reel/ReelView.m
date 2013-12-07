//
//  ReelView.m
//  Film_Reel
//
//  Created by Ben Sweett on 12/7/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "ReelView.h"

@interface ReelView ()

@end

@implementation ReelView

@synthesize currentReel;
@synthesize imageView;
@synthesize downloadPath;
@synthesize networking;

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
    networking = [[Networking alloc]init];
	downloadPath = [currentReel getImagePath];
    [imageView setImage:[networking downloadImageFromServer:downloadPath]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
