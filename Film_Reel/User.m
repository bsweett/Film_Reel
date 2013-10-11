//
//  User.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-07.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userName;
@synthesize displayPicture;
@synthesize email;
@synthesize location;
@synthesize userBio;
@synthesize friendsList;
@synthesize friendCount;

// Constructor -------------------------------------------------------------------
-(id) init
{
    self = [super init];
    
    if(self)
    {
        userName = [[NSMutableString alloc] initWithFormat:@""];
        displayPicture= [[UIImage alloc] init];
        email = @"";
        location = [[NSMutableString alloc] initWithFormat:@""];
        userBio = [[NSMutableString alloc] initWithFormat:@""];
        friendCount = 0;
        friendsList = [[NSMutableArray alloc] init];
    }
    
    return self;
}
// -------------------------------------------------------------------------------

// Get Values --------------------------------------------------------------------
- (NSMutableString*) getUserName  { return userName;    }
- (NSMutableString*) getLocation  { return location;    }
- (NSString*) getEmail            { return email;       }
- (NSMutableString*) getUserBio   { return userBio;     }
- (NSMutableArray*) getFriendList { return friendsList; }
- (NSInteger*) getFriendCount     { return friendCount; }
// -------------------------------------------------------------------------------

// Set Values --------------------------------------------------------------------
- (void) setUserName: (NSMutableString*) name   { userName = name;               }
- (void) setLocation: (NSMutableString*) place  { location = place;              }
- (void) setEmail:    (NSString*) eAddress      { email = eAddress;              }
- (void) setUserBio:  (NSMutableString*) bio    { userBio = bio;                 }
- (void) incrementCount                         { friendCount = friendCount + 1; }
- (void) decrementCount                         { friendCount = friendCount - 1; }
// -------------------------------------------------------------------------------

// These functions handle all the friendList searching, adding, and Removing -----
- (BOOL) addFriend:(User *)userToAdd
{
    if(userToAdd != NULL && userName != NULL)
    // We will need to check somewhere else that the user is signed up correctly
    // Here we just add them to the list if the object and name exist
    {
        [friendsList addObject:userToAdd];
        [self incrementCount];
        return TRUE;
    } else
    // Return False and handle error properly
    {
        return FALSE;
    }
}

- (BOOL) deleteFriend: (User *) userToRemove
{
    if(userToRemove != NULL) { // Add check if user is in list
        [friendsList removeObject:userToRemove];
        [self decrementCount];
        return TRUE;
    } else
    {
        return FALSE;
    }
}

- (User *) getUserByName: (NSMutableString *) name
{
    return NULL;
}

-(void) sortFriendList
{
    
    
}

// ------------------------------------------------------------------------------


- (BOOL)validateEmailWithString:(NSString*)emailaddress;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailaddress];
}

@end
