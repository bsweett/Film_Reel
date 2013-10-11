//
//  User.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-07.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSMutableString * userName;
@property (strong, nonatomic) UIImage * displayPicture;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSMutableString* location; // dropdown menu?
@property (strong, nonatomic) NSMutableString * userBio;
@property (strong, nonatomic) NSMutableArray * friendsList;
@property (nonatomic) NSInteger * friendCount;

// Getters
- (NSMutableString*) getUserName;
- (NSMutableString*) getLocation;
- (NSString*) getEmail;
- (NSMutableString*) getUserBio;
- (NSMutableArray*) getFriendList;
- (NSInteger*) getFriendCount;

// Setters
- (void) setUserName: (NSMutableString*) name;
- (void) setLocation: (NSMutableString*) place;
- (void) setEmail: (NSString*) eAddress;
- (void) setUserBio: (NSMutableString*) bio;
- (void) incrementCount;
- (void) decrementCount;

// FriendList Methods
- (BOOL) addFriend: (User *) userToAdd;
- (BOOL) deleteFriend: (User *) userToRemove;
- (User *) getUserByName: (NSMutableString*) name;
- (void) sortFriendList: (User *) toget;

// Validatation
- (BOOL) validateEmailWithString:(NSString*)emailaddress;




@end
