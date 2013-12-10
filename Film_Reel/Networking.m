//
//  UserXMLParser.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-11.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  This class handles all of the networking operations, requests, and uploading. It sends
//  notifications to the view controllers based on what is prasered from the XML Data that
//  is returned from the server.
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
@synthesize reelObject;
@synthesize reelArray;

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

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark URL & Connection Control
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Sets up a connection and a manager with a URL based on the URL passed from a 
 * veiw controller. The type of request is stored for latter validation.
 *
 * @param defaultURL url for request
 * @param  typeOfRequest   Request type for assigning proper notifications
 */

- (void) startReceive: (NSString *) defaultURL withType:(NSString *) typeOfRequest
{
    BOOL succuss;
    NSURL  * address;
    NSURLRequest * request;
    
    requestType = typeOfRequest;
    
    assert(self.connection == nil);
    address = [[NetworkManager sharedInstance] smartURLForString:defaultURL];
    succuss = (address != nil);
    
    if( ! succuss)
    {
        // Update with error status
        [[NSNotificationCenter defaultCenter]postNotificationName:@ADDRESS_FAIL object:self];
    }
    else
    {
        request = [NSURLRequest requestWithURL:address cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
        assert(request != nil);
        
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
        assert(self.connection != nil);
        
        [self receiveDidStart];
    }
}


/**
 * Returns BOOL based on if connection is open or not. Used to update UI
 *
 */
- (BOOL)isReceiving { return (self.connection != nil); }


/**
 * Start connection manager
 *
 */
- (void) receiveDidStart
{
    LogInfo(@"CONNECTION OPENED\n");
    [[NetworkManager sharedInstance] didStartNetworkOperation];
}


/**
 * cancels connection sends a status string
 *
 */
- (void)stopReceiveWithStatus:(NSString *)statusString
{
    if (self.connection != nil) {
        [self.connection cancel];
        self.connection = nil;
    }
    
    [self receiveDidStopWithStatus:statusString];
}


/**
 * handle which status send on stopping manager
 *
 * @param status A status message passed from server
 */
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
            
            
            if([localMessage isEqualToString:@"Error"])
            {
                // Exception throw by server
                [[NSNotificationCenter defaultCenter]postNotificationName:@ERROR_STATUS object:nil];
            }
            else if([localMessage isEqualToString:@"Fail"])
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
            else if([requestType isEqualToString: @UPDATE_REQUEST])
            {
                [self isValidUpdateRequest:localMessage];
            }
            else if([requestType isEqualToString: @REEL_SEND])
            {
                [self isValidReelRequest: localMessage];
            }
            else if([requestType isEqualToString: @FRIEND_REQUEST])
            {
                [self isValidFriendRequest:localMessage];
            }
            else if([requestType isEqualToString: @DATA_REQUEST])
            {
                [self isValidDataRequest:localMessage];
            }
            else if([requestType isEqualToString:@INBOX_REQUEST])
            {
                [self isValidInboxRequest:localMessage];
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@FAIL_STATUS object:nil];
    }
}

///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

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
    NSLog(@"CONNECTION ERROR:: %@", message);
    [self stopReceiveWithStatus:message];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
// A delegate method called by the NSURLConnection when the connection has been
// done successfully.  We shut down the connection with a nil status, which
// causes the image to be displayed.
{
    assert(theConnection == self.connection);
    NSLog(@"CONNECTION CLOSED\n");
    [self stopReceiveWithStatus:nil];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Notification Managing
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Check message and send notification for valid login or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidLoginRequest: (NSString*) localMessage
{
    if ([localMessage isEqualToString:@"UserNotFound"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else    // Pass user object
    {
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@CURRENT_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@LOGIN_SUCCESS object:nil userInfo:userDictionary];
    }
}


/**
 * Check message and send notification for valid friend request or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidFriendRequest: (NSString*) localMessage
{
    if ([localMessage isEqualToString:@"UserNotFound"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else if([localMessage isEqualToString:@"AlreadyFriends"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@ALREADY_FRIENDS object:nil];
    }
    else if([localMessage isEqualToString:@"InvalidToken"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@TOKEN_IS_INVALID_ADD_FRIEND object:nil];
    }
    else    // Pass user object
    {
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@CURRENT_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@FRIEND_SUCCESS object:nil userInfo:userDictionary];
    }
}


/**
 * Check message and send notification for valid signup or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidSignUpRequest: (NSString*) localMessage
{
    if ([localMessage isEqualToString:@"UserAlreadyExists"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@USER_ALREADY_EXISTS object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@SIGNUP_SUCCESS object:nil];
    }
}


/**
 * Check message and send notification for valid update or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidUpdateRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"UserNotFound"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@UPDATE_SUCCESS object:nil];
    }
}


/**
 * Check message and send notification for valid token or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidTokeLoginRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"Invalid"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@INVALID_TOKEN object:nil];
    }
    else
    {
         NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@CURRENT_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@VALID_SUCCESS object:nil userInfo:userDictionary];
    }
}


/**
 * Check message and send notification for valid data or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidDataRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"UserNotFound"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else
    {
        NSDictionary* userDictionary = [NSDictionary dictionaryWithObject:userObject forKey:@FRIEND_USER];
        [[NSNotificationCenter defaultCenter]postNotificationName:@DATA_SUCCESS object:nil userInfo:userDictionary];
    }
}


/**
 * Check message and send notification for valid inbox or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidInboxRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"NoNewMail"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@EMPTY_INBOX object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@INBOX_SUCCESS  object:nil userInfo:dataReceived];
    }
}


/**
 * Check message and send notification for valid reel or error
 *
 * @param localMessage A status message passed from server
 */
- (void) isValidReelRequest: (NSString*) localMessage
{
    if([localMessage isEqualToString:@"UserNotFound"])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@USER_NOT_FOUND object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@REEL_SUCCESS  object:nil userInfo:dataReceived];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Parser Delegate
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * XMLParser Delegate Method. Finds starting elements in xml data
 *
 */
- (void)parser:(NSXMLParser*)parser didStartElement:(NSString *)elementName namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary*)attributeDict
{
    if([elementName isEqualToString:@"data"])
    {
        dataReceived = [[NSMutableDictionary alloc] init];
        currentObject = [[NSMutableString alloc]init];
        reelArray = [[NSMutableArray alloc] init];
        LogInfo(@"PARSER:: Found Data Element");
    }
    
    if([elementName isEqualToString:@"user"])
    {
        userObject = [[User alloc] init];
        dataReceived = [[NSMutableDictionary alloc] init];
        currentObject = [[NSMutableString alloc]init];
        LogInfo(@"PARSER:: Found User Element");
    }
    
    if([elementName isEqualToString:@"snap"])
    {
        reelObject = [[Reel alloc]init];
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
    if([elementName isEqualToString:@"reelcount"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"message"])
    {
       currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"friends"])
    {
        currentObject = [[NSMutableString alloc]init];
    }
    if([elementName isEqualToString:@"gender"])
    {
        currentObject = [[NSMutableString alloc] init];
    }
    if([elementName isEqualToString:@"reel"])
    {
        currentObject = [[NSMutableString alloc] init];
    }
    if([elementName isEqualToString:@"pop"])
    {
        currentObject = [[NSMutableString alloc] init];
    }
}


/**
 * XMLParser Delegate Method. Finds End elements in xml data
 *
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    LogInfo(@"PARSER:: Found end of: %@", elementName);
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
    if([elementName isEqualToString:@"gender"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"pop"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"image"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"reelcount"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"reel"])
    {
        [dataReceived setObject:[self seperateReelData:currentObject] forKey:@INBOX_DATA];
    }
    if([elementName isEqualToString:@"message"])
    {
        LogInfo(@"PARSER:: Server's message was %@", currentObject);
        [dataReceived setObject:currentObject forKey:elementName];
    }
    if([elementName isEqualToString:@"friends"])
    {
        [dataReceived setObject:currentObject forKey:elementName];
        [self seperateFriends:currentObject andUser:userObject];
    }
    if([elementName isEqualToString:@"user"]) {
        [userObject setUserName:[dataReceived objectForKey:@"name"]];
        [userObject setPassword:[dataReceived objectForKey:@"password"]];
        [userObject setToken:[dataReceived objectForKey:@"token"]];
        [userObject setUserBio:[dataReceived objectForKey:@"bio"]];
        [userObject setLocation:[dataReceived objectForKey:@"location"]];
        [userObject setEmail:[dataReceived objectForKey:@"email"]];
        [userObject setGender:[dataReceived objectForKey:@"gender"]];
        [userObject setPopularity:[dataReceived objectForKey:@"pop"]];
        [userObject setDisplayPicturePath:[dataReceived objectForKey:@"image"]];
        [userObject setReelCount:[dataReceived objectForKey:@"reelcount"]];
        [dataReceived setObject:userObject forKey:@"user"];
    }
}


/**
 * XMLParser Delegate Method. Finds characters in between tag elements
 *
 */
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentObject appendString:[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Data Seperation
#pragma mark -
///////////////////////////////////////////////////////////////////////////

/**
 * Seperates Data in a reel string. A reel string contains a sender email
 * and a imagepath to where reel is stored
 *
 * @param reelString A reelString passed from server
 * @return arrayOfReels  An array with all the reels in it
 */
- (NSMutableArray *)seperateReelData:(NSString*)reelString
{
    NSArray *reels = [reelString componentsSeparatedByString:@"-"];
    NSMutableArray *arrayOfReels = [[NSMutableArray alloc] init];
    
    for(int i=1; i < [reels count] -1; i+=2)
    {
        Reel *reel = [[Reel alloc]init];
        [reel setSender:[reels objectAtIndex:i-1]];
        [reel setImagePath:[reels objectAtIndex:i]];
        [arrayOfReels addObject:reel];
    }
    
    return arrayOfReels;
}


/**
 * Seperates Data in a friendString. A friend string contains all friends
 * emails with "-"
 *
 * @param friendString A reelString passed from server
 * @param user currnent User Object
 */

- (void)seperateFriends:(NSString *)friendsString andUser: (User *)user
{

    NSArray *friends = [friendsString componentsSeparatedByString:@"-"];
    
    for(int i=1; i < [friends count] - 1; i+=2)
    {
        [user addFriend:[friends objectAtIndex:i] withEmail:[friends objectAtIndex:i-1]];
    }
}


///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Image Upload and Download
#pragma mark -
///////////////////////////////////////////////////////////////////////////


/**
 * Posts Image to server as a HTTP Post and post notification if a response is sent
 *
 * @param dataImage Image to send as JPG Data
 * @param filename  A filename to call the image on the server
 */
-(void)saveImageToServer: (NSData*) dataImage withFileName: (NSString*) filename
{
    NSString *urlString = @SERVER_ADDRESS"fileuploadaction.action";
    
    // Create 'POST' MutableRequest with Data and Other Image Attachment.
    NSMutableURLRequest* request= [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *postbody = [NSMutableData data];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"fileUpload\"; filename=\"%@.jpg\"\r\n", filename]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: image/jpeg \r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[NSData dataWithData:dataImage]];
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postbody];
    
    // Get Response of Request
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *responseString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    LogInfo(@"SERVER:: Image Upload Response -- %@",responseString);
    
    // Put reponse in dictionary and send notifcation
    if(responseString != nil)
    {
        NSDictionary* responseDictionary = [NSDictionary dictionaryWithObject:responseString forKey:@POST_RESPONSE];
        [[NSNotificationCenter defaultCenter]postNotificationName:@RESPONSE_FOR_POST object:nil userInfo:responseDictionary];
    }
}


/**
 * Grabs image from a url
 *
 * @param url Url to grab image from
 * @return A UIImage
 */
-(UIImage *) downloadImageFromServer: (NSString *) url
{  
    NSMutableString *urlAddress = [[NSMutableString alloc]initWithString:@SERVER_UPLOAD_ADDRESS];
    [urlAddress appendString:url];
    [urlAddress appendString:@".jpg"];
      NSLog(@"The url is: %@", urlAddress);
    NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlAddress]];
    return [UIImage imageWithData: imageData];
}

@end
