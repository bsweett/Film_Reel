//
//  Reel.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface Reel : NSObject <AVCaptureAudioDataOutputSampleBufferDelegate>

@property (strong, nonatomic) NSMutableArray * imagesArray;
@property (strong, nonatomic) AVAsset* video;
@property (strong, nonatomic) AVAssetTrack *editingvideo;
@property (strong, nonatomic) NSString* reelTitle; // Do we need this?

@end
