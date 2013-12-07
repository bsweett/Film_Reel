//
//  ReelView.h
//  Film_Reel
//
//  Created by Ben Sweett on 12/7/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reel.h"

@interface ReelView : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView* imageView;
@property (nonatomic, strong) Reel* currentReel;

@end
