//
//  ImageUploadEngine.h
//  Film_Reel
//
//  Created by Ben Sweett on 12/2/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "MKNetworkEngine.h"

@interface ImageUploadEngine : MKNetworkEngine

-(MKNetworkOperation *) postDataToServer:(NSMutableDictionary *)params path:(NSString *)path;

@end
