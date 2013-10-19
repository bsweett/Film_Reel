//
//  UserXMLParser.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "UserXMLParser.h"

static NSString * defaultURL = @""; // This will have to be hardcoded to an XML page generated on appache server

@implementation UserXMLParser

@synthesize parser;
@synthesize connection;
@synthesize data;

- (id) init
{
    
    self = [super init];
    
    if(self)
    {
        NSString * blank = @"";
        const char * utfformatted = [blank UTF8String];
        data = [NSMutableData dataWithBytes:utfformatted length:(strlen(utfformatted))];
    }
    
    return self;
}

- (void) startReceive
{
    BOOL succuss;
    NSURL  * address;
    NSURLRequest * request;
    
    assert(self.connection == nil);
    address = [[NetworkManager sharedInstance] smartURLForString: defaultURL];
    succuss = (address != nil);
    
    if( ! succuss)
    {
        // Update with error status
    } else {
        request = [NSURLRequest requestWithURL:address];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        
        [self receiveDidStart];
    }
}

- (BOOL)isReceiving
{
    return (self.connection != nil);
}

- (void) receiveDidStart
{
    //Update UI with Status
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void) receiveDidStopWithStatus: (NSString *) status
{
    if(status == nil)
    {
        status = @"Succeed";
    }
    //Update UI with Status
    [[NetworkManager sharedInstance] didStopNetworkOperation];
    
    
    // Update UI Get Button etc...
    
}

- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    [self receiveDidStopWithStatus:statusString];
    
}

- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)theData
// A delegate method called by the NSURLConnection as data arrives.
{
    assert(theConnection == self.connection);
    
    // Process the data you received here
    [data appendData:theData];
    
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
// A delegate method called by the NSURLConnection if the connection fails.
// We shut down the connection and display the failure.  Production quality code
// would either display or log the actual error.
{
    assert(theConnection == self.connection);
    NSLog(@"%@",[error localizedDescription]);
    [self stopReceiveWithStatus:@"Connection failed"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
    assert(theConnection == self.connection);
    
    [self stopReceiveWithStatus:nil];
    
    parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    for( int i = 0; i < 10; i++ )
    {
       // Data is finished loading update accordingly
    }
    
}


@end
