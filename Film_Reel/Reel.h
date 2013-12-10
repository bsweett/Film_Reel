//
//  Reel.h
//  Film_Reel
//
//  Created by Brayden Girard on 12/6/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Reel Object that is used to hold reels when they arrive for the inbox

#import <Foundation/Foundation.h>

@interface Reel : NSObject

@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *imagePath;

-(void)setSender:(NSString *)s;
-(void)setImagePath:(NSString *)i;

-(NSString *) getSender;
-(NSString *) getImagePath;


@end
