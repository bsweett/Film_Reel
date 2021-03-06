//
//  NetworkManager.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-05.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  Manages Networking thread and parsers URL string into a proper URL format
//

#import "NetworkManager.h"

@interface NetworkManager ()

// read/write redeclaration of public read-only property

@property (nonatomic, assign, readwrite) NSUInteger networkOperationCount;

@end

@implementation NetworkManager

@synthesize networkOperationCount = _networkOperationCount;

+ (NetworkManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static NetworkManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[NetworkManager alloc] init];
    });
    return sSharedInstance;
}

- (NSURL *) smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) )
    {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound)
        {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        }
        else
        {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) )
            {
                result = [NSURL URLWithString:trimmedStr];
            }
            else
            {
                NSLog(@"CONNECTION ERROR:: Unsupported URL scheme");
            }
        }
    }
    
    return result;
}

- (void)didStartNetworkOperation
{
    // If you start a network operation off the main thread, you'll have to update this code
    // to ensure that any observers of this property are thread safe.
    assert([NSThread isMainThread]);
    self.networkOperationCount += 1;
}

- (void)didStopNetworkOperation
{
    // If you stop a network operation off the main thread, you'll have to update this code
    // to ensure that any observers of this property are thread safe.
    assert([NSThread isMainThread]);
    assert(self.networkOperationCount > 0);
    self.networkOperationCount -= 1;
}

@end

