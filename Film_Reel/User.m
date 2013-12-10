//
//  User.m
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-07.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//
//  User Object for current User and a friend everytime they are viewed

#import "User.h"

@implementation User

@synthesize userName;
@synthesize token;
@synthesize displayPicture;
@synthesize email;
@synthesize location;
@synthesize userBio;
@synthesize password;
@synthesize displayPicturePath;
@synthesize gender;
@synthesize popularity;
@synthesize friendsList;
@synthesize friendCount;
@synthesize reelCount;

// Constructor -------------------------------------------------------------------
-(id) init
{
    self = [super init];
    
    if(self)
    {
        userName       = [[NSMutableString alloc] initWithCapacity:MAX_USER_SIZE];
        displayPicture = [[UIImage alloc] init];
        email          = [[NSMutableString alloc] initWithCapacity:MAX_EMAIL_SIZE];
        location       = [[NSMutableString alloc] initWithCapacity:MAX_LOCATION_SIZE];
        userBio        = [[NSMutableString alloc] initWithCapacity:MAX_BIO_SIZE];
        friendCount    = 0;
        friendsList    = [[NSMutableDictionary alloc] initWithCapacity:MAX_FRIENDS_SIZE];
        token          = @"";
        popularity     = 0;
        gender         = [[NSMutableString alloc] initWithCapacity:1];
    }
    
    return self;
}

// Get Values --------------------------------------------------------------------
- (NSMutableString*) getUserName       { return userName;       }
- (NSString *) getToken                { return token;          }
- (UIImage *) getDP                    { return displayPicture; }
- (NSMutableString*) getLocation       { return location;       }
- (NSString*) getEmail                 { return email;          }
- (NSMutableString*) getUserBio        { return userBio;        }
- (NSMutableString*) getPassword       { return password;       }
- (NSString*) getDisplayPicturePath    { return displayPicturePath;}
- (NSMutableDictionary*) getFriendList { return friendsList;    }
- (NSInteger*) getFriendCount          { return friendCount;    }
- (NSMutableString*) getPopularity     { return popularity;     }
- (NSMutableString*) getGender         { return gender;         }
- (NSMutableString*) getReelCount      { return reelCount;      }

// Set Values --------------------------------------------------------------------
- (void) setUserName:  (NSMutableString*) name     { userName        = name;            }
- (void) setToken:     (NSString *)validToken      { token           = validToken;      }
- (void) setLocation:  (NSMutableString*) place    { location        = place;           }
- (void) setEmail:     (NSMutableString*) eAddress { email           = eAddress;        }
- (void) setUserBio:   (NSMutableString*) bio      { userBio         = bio;             }
- (void) setPassword:  (NSMutableString *)pass     { password        = pass;            }
- (void) setDisplayPicturePath: (NSString *) imagePath  { displayPicturePath = imagePath;}
- (void) setDisplayPicture:(UIImage *)DP                { displayPicture = DP; }
- (void) incrementCount                            { friendCount     = friendCount + 1; }
- (void) decrementCount                            { friendCount     = friendCount - 1; }
- (void) setPopularity:(NSMutableString*)pop       { popularity      = pop;             }
- (void) setGender:    (NSMutableString *)sex      { gender          = sex;             }
- (void) setReelCount:(NSMutableString *)count     { reelCount       = count;           }


// Sets up Image from file data provided from server
// UNUSED
- (void) setUpImageFromData: (NSData*) data
{
    if(data != NULL)
    {
        UIImage * dp   = [[UIImage alloc] initWithData:data];
        displayPicture = dp;
    } else
    {
        NSString *thePath   = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"png"];
        UIImage* errorImage = [[UIImage alloc] initWithContentsOfFile:thePath];
        displayPicture = errorImage;
    }
}

// These functions handle all the friendList searching, adding, and Removing -----
- (void) addFriend:(NSString *)userToAdd withEmail: (NSString *) emailAddress
{
    if(userToAdd != NULL)
    // We will need to check somewhere else that the user is signed up correctly
    // Here we just add them to the list if the object and name exist
    {
        [friendsList setObject:userToAdd forKey:emailAddress];
        [self incrementCount];
    }
}

// UNUSED
- (void) deleteFriend: (NSString *) userToRemove
{
        [friendsList removeObjectForKey:userToRemove];
        [self decrementCount];
}

// Returns NULL if object doesnt exist
// UNUSED
- (void) updateUserByEmail: (NSString *) emailAddress andNewName: (NSString *) currentName
{
    if([friendsList objectForKey:emailAddress] != NULL) {
        if([[friendsList objectForKey:emailAddress] isEqualToString:currentName]) {
            [friendsList setObject:currentName forKey:emailAddress];
        }
    }
}

@end
