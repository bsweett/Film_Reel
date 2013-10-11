//
//  User.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-07.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import "User.h"

#define MAX_USER_SIZE 30
#define MAX_LOCATION_SIZE 15
#define MAX_BIO_SIZE 160
#define MAX_FRIENDS_SIZE 99

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
        userName = [[NSMutableString alloc] initWithCapacity:MAX_USER_SIZE];
        displayPicture= [[UIImage alloc] init];
        email = @"";
        location = [[NSMutableString alloc] initWithCapacity:MAX_LOCATION_SIZE];
        userBio = [[NSMutableString alloc] initWithCapacity:MAX_BIO_SIZE];
        friendCount = 0;
        friendsList = [[NSMutableArray alloc] initWithCapacity:MAX_FRIENDS_SIZE];
    }
    
    return self;
}

// Get Values --------------------------------------------------------------------
- (NSMutableString*) getUserName  { return userName;    }
- (NSMutableString*) getLocation  { return location;    }
- (NSString*) getEmail            { return email;       }
- (NSMutableString*) getUserBio   { return userBio;     }
- (NSMutableArray*) getFriendList { return friendsList; }
- (NSInteger*) getFriendCount     { return friendCount; }

// Set Values --------------------------------------------------------------------
- (void) setUserName: (NSMutableString*) name   { userName = name;               }
- (void) setLocation: (NSMutableString*) place  { location = place;              }
- (void) setEmail:    (NSString*) eAddress      { email = eAddress;              }
- (void) setUserBio:  (NSMutableString*) bio    { userBio = bio;                 }
- (void) incrementCount                         { friendCount = friendCount + 1; }
- (void) decrementCount                         { friendCount = friendCount - 1; }

// These functions handle all the friendList searching, adding, and Removing -----
- (BOOL) addFriend:(User *)userToAdd
{
    if(userToAdd != NULL && userName != NULL)
    // We will need to check somewhere else that the user is signed up correctly
    // Here we just add them to the list if the object and name exist
    {
        [friendsList addObject:userToAdd];
        [self incrementCount];
        
        // Update the other users list to have this user on it
        [userToAdd.friendsList addObject:self];
        [userToAdd incrementCount];
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
        
        // Update the other users list to remove this user from it
        [userToRemove.friendsList removeObject:self];
        [userToRemove decrementCount];
        return TRUE;
    } else
    {
        return FALSE;
    }
}

// Returns NULL if object doesnt exist
- (User *) getUserByName: (User *) toget
{
    if([self.friendsList containsObject:toget.userName] == TRUE) {
        int getindex = [self.friendsList containsObject:toget.userName];
        return [self.friendsList objectAtIndex:getindex];
    } else {
        return NULL;
    }
}


// Sorts friendlist by username
-(void) sortFriendList: (User* ) tosort
{
    NSSortDescriptor *sortDescriptor =
    [NSSortDescriptor sortDescriptorWithKey:@"userName"
                                  ascending:YES
                                   selector:@selector(caseInsensitiveCompare:)];
    [tosort.friendsList sortedArrayUsingDescriptors:@[sortDescriptor]];
}


// Validations --------------------------------------------------------------------
- (BOOL)validateEmailWithString:(NSString*)emailaddress;
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailaddress];
}

@end
