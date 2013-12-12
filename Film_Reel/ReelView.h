//
//  ReelView.h
//  Film_Reel
//
//  Created by Ben Sweett on 12/7/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Fairly simple view for viewing a reel from an inbox
//
//  TODO:: Make this UI look nicer

#import <UIKit/UIKit.h>
#import "Reel.h"
#import "Networking.h"

@interface ReelView : UIViewController

#pragma mark Defined Objects
@property (nonatomic, strong) Networking *networking;
@property (nonatomic, strong) Reel* currentReel;

#pragma mark IBOutlets and UI
@property (nonatomic, strong) IBOutlet UIImageView* imageView;

#pragma mark Download Path for Image
@property (nonatomic, strong) NSString *downloadPath;

///////////////////////////////////////////////////////////////////////////

@end
