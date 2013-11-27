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
@synthesize dataReceived;
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
        [[NSNotificationCenter defaultCenter]postNotificationName:@ADDRESS_FAIL object:self];
    } else {
        request = [NSURLRequest requestWithURL:address cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
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
        
        parser = [[NSXMLParser alloc] initWithData:data];
        [parser setDelegate:self];
        [parser parse];
        
        if(dataReceived != nil)
        {
            NSString *localMessage = [dataReceived objectForKey:@"message"];
            
            // check what type of request it is
            if([localMessage isEqualToString:@"Fail"])
            {
                // This is a fault in the request address
                // Should never happen
                [[NSNotificationCenter defaultCenter]postNotificationName:@FAIL_STATUS object:nil];
            }
            else if([requestType isEqualToString:@VALID_REQUEST])
            {
                [self isValidTokeLoginRequest:localMessage];
            }
            else if([requestType isEqualToString: @LOGIN_REQUEST])
            {
                [self isValidLoginRequest:localMessage];
            }
            else if([requestType isEqualToString: @SIGNUP_REQUEST])
            {
                [self isValidSignUpRequest: localMessage];
            }
            else if([requestType isEqualToString: @FETCH_REQUEST])
            {
                [self isValidFetchRequest:localMessage];
            }
            else if([requestType isEqualToString: @UPDATE_REQUEST])
            {
                [self isValidUpdateRequest:localMessage];
            }
            else if([requestType isEqualToString: @REEL_SEND])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@REEL_SUCCESS object:nil];
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@FAIL_STATUS object:nil];
    }
}

- (void) isValidLoginRequest: (NSString*) localMessage
{
    if ([localMessage isEqualToString:@"NoUserFound"])
    {
        NSLog(@"Message no user found: %@", [dataReceived objectForKey:@"message"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else    // Pass user object
    {
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@CURRENT_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@LOGIN_SUCCESS object:nil userInfo:userDictionary];
    }
}

- (void) isValidSignUpRequest: (NSString*) localMessage
{
    if ([localMessage isEqualToString:@"UserAlreadyExists"])
    {
        NSLog(@"Message user already exists: %@", [dataReceived objectForKey:@"message"]);
        [[NSNotificationCenter defaultCenter]postNotificationName:@USER_ALREADY_EXISTS object:nil];
    }
    else
    {
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@CURRENT_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@SIGNUP_SUCCESS object:nil userInfo:userDictionary];
    }
}

- (void) isValidFetchRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@""])
    {
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@FETCH_SUCCESS object:nil];
    }
}

- (void) isValidUpdateRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@""])
    {
     
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@UPDATE_SUCCESS object:nil];
    }
}

- (void) isValidTokeLoginRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"Invalid"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@INVALID_TOKEN object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@VALID_SUCCESS object:nil];
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
    NSLog(@"Did stop\n");
    [self stopReceiveWithStatus:nil];
}

//-----------------------------
// Parser

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if([elementName isEqualToString:@"data"])
    {
        dataReceived = [[NSMutableDictionary alloc] init];
        currentObject = [[NSMutableString alloc]init];
        NSLog(@"found Data Element");
    }
    
    if([elementName isEqualToString:@"user"])
    {
        userObject = [[User alloc] init];
        dataReceived = [[NSMutableDictionary alloc] init];
        currentObject = [[NSMutableString alloc]init];
        NSLog(@"found User Element");
    }
    
    if([elementName isEqualToString:@"name"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"email"])
    {
       currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"location"])
    {
       currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"token"])
    {
       currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"bio"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"password"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"image"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"message"])
    {
       currentObject = [[NSMutableString alloc]init];
        NSLog(@"The messsage was: %@", currentObject);
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"found end: %@", elementName);
    if([elementName isEqualToString:@"name"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"email"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"location"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"token"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"bio"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"password"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"image"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"message"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"user"]) {
        [userObject setUserName:[dataReceived objectForKey:@"name"]];
        [userObject setPassword:[dataReceived objectForKey:@"password"]];
        [userObject setToken:[dataReceived objectForKey:@"token"]];
        [userObject setUserBio:[dataReceived objectForKey:@"bio"]];
        [userObject setLocation:[dataReceived objectForKey:@"location"]];
        [userObject setEmail:[dataReceived objectForKey:@"email"]];
        [userObject setImagePath:[dataReceived objectForKey:@"image"]];
        [dataReceived setObject:userObject forKey:@"user"];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentObject appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}


@end
