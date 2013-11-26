//
//  UserXMLParser.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "Networking.h"

@implementation Networking

@synthesize connection;
@synthesize data;
@synthesize parser;
@synthesize requestType;

@synthesize userObject;
@synthesize currentObject;

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

- (void) startReceive: (NSString *) defaultURL withType:(NSString *) typeOfRequest
{
    BOOL succuss;
    NSURL  * address;
    NSURLRequest * request;
    
    requestType = typeOfRequest;
    
    assert(self.connection == nil);
    address = [[NetworkManager sharedInstance] smartURLForString: defaultURL];
    succuss = (address != nil);
    
    if( ! succuss)
    {
        // Update with error status
        [[NSNotificationCenter defaultCenter]postNotificationName:@"AddressFailed" object:self];
    } else {
        request = [NSURLRequest requestWithURL:address cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
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
    NSLog(@"Did Start\n");
    //Update UI with Status
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}

- (void) receiveDidStopWithStatus: (NSString *) status
{
    if(status == nil)
    {
        status = @"Succeed";
        [[NetworkManager sharedInstance] didStopNetworkOperation];
        
        if(userObject != nil && [userObject getToken] != nil)
        {
            NSString* localToken = [userObject getToken];
            // check what type of request it is
            if([requestType isEqualToString: @LOGIN_REQUEST])
            {
                [self isValidLoginRequest:localToken];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SucceedStatus" object:nil];
                NSLog(@"SucceedStatus");
            }
            else if([requestType isEqualToString: @SIGNUP_REQUEST])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"SIGN_UP" object:nil];
            }
            else if([requestType isEqualToString: @FETCH_REQUEST])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"FETCH_COMPLETE" object:nil];
            }
            else if([requestType isEqualToString: @UPDATE_REQUEST])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UPDATE" object:nil];
            }
            else if([requestType isEqualToString: @REEL_SEND])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"REEL_SENT" object:nil];
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"FailStatus" object:nil];
        NSLog(@"Sent Fail notification\n");
    }
}

- (void) isValidLoginRequest: (NSString*) localToken
{
    if([localToken isEqualToString:@"Fail"])
    {
        // Invalid parameter request
    }
    else if ([localToken isEqualToString:@"NoUserFound"])
    {
        // Login by username and password failed
    }
    else // check validToken
    {
        
    }
}

- (void) isValidSignUpRequest
{
    NSString* localToken = [userObject getToken];
    if([localToken isEqualToString:@"Fail"])
    {
        
    }
    else if ([localToken isEqualToString:@"UserAlreadyExists"])
    {
        
    }
    else
    {
        
    }
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
    
    NSString * message = [error localizedDescription];
    NSLog(@"Error:: %@", message);
    [self stopReceiveWithStatus:message];
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
    
    
    
       // Data is finished loading update accordingly
    
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if([elementName isEqualToString:@"user"])
    {
        userObject = [[User alloc] init];
        NSLog(@"found User Element");
    }
    
    if([elementName isEqualToString:@"token"])
    {
        currentObject = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"name"])
    {
        [userObject setUserName: currentObject];
    }
    if([elementName isEqualToString:@"email"])
    {
        [userObject setEmail: currentObject];
    }
    if([elementName isEqualToString:@"location"])
    {
        [userObject setLocation: currentObject];
    }
    if([elementName isEqualToString:@"token"])
    {
        [userObject setToken: currentObject];
    }
    if([elementName isEqualToString:@"userbio"])
    {
        [userObject setUserBio: currentObject];
    }
    if([elementName isEqualToString:@"password"])
    {
        [userObject setPassword: currentObject];
    }
    if([elementName isEqualToString:@"imagepath"])
    {
        [userObject setImagePath: currentObject];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentObject appendString:string];
}


@end
