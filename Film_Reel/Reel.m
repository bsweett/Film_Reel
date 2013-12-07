//
//  Reel.m
//  Film_Reel
//
//  Created by Brayden Girard on 12/6/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "Reel.h"

@implementation Reel

@synthesize sender;
@synthesize imagePath;

-(void)setSender:(NSString *)s
{
    sender = s;
}
-(void)setImagePath:(NSString *)i
{
    imagePath = i;
}

-(NSString *) getSender
{
    return sender;
}

-(NSString *) getImagePath
{
    return imagePath;
}





@end
