//
//  ReelView.m
//  Film_Reel
//
//  Created by Ben Sweett on 12/7/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Fairly simple view for viewing a reel from an inbox
//
//  TODO:: Make this UI look nicer

#import "ReelView.h"

@interface ReelView ()

@end

@implementation ReelView

@synthesize currentReel;
@synthesize imageView;
@synthesize downloadPath;
@synthesize networking;

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
        // Custom initialization
    }
    return self;
}

/**
 * This method is called when the ReelView is loaded for the first
 * time. Downloads image and sets it in the view
 *
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    networking = [[Networking alloc]init];
	downloadPath = [currentReel getImagePath];
    [imageView setImage:[networking downloadImageFromServer:downloadPath]];
}

/**
 * Handles any memory warnings sent from the OS
 *
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    LogDebug(@"Memory Warning");
}

@end
