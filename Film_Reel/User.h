//
//  User.h
//  Film_Reel
//
//  Created by Ben Sweett on 2013-10-07.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSMutableString     * userName;
@property (strong, nonatomic) UIImage             * displayPicture;
@property (strong, nonatomic) NSMutableString     * email;
@property (strong, nonatomic) NSMutableString     * location; // dropdown menu?
@property (strong, nonatomic) NSMutableString     * userBio;
@property (strong, nonatomic) NSMutableString     * password;
@property (strong, nonatomic) NSMutableString     * gender;
@property (strong, nonatomic) NSString            * displayPicturePath;
@property (strong, nonatomic) NSMutableDictionary * friendsList;
@property (nonatomic        ) NSInteger           * friendCount;
@property (strong, nonatomic) NSString            * token;
@property (strong, nonatomic) NSMutableString     * popularity;

// Getters
- (NSMutableString*) getUserName;
- (NSString *) getToken;
- (UIImage *) getDP;
- (NSMutableString*) getLocation;
- (NSString*) getEmail;
- (NSMutableString*) getUserBio;
- (NSMutableString*) getPassword;
- (NSString*) getDisplayPicturePath;
- (NSMutableDictionary*) getFriendList;
- (NSInteger*) getFriendCount;
- (NSMutableString*) getGender;
- (NSMutableString*) getPopularity;

// Setters
- (void) setUserName: (NSMutableString*) name;
- (void) setToken:(NSString *)validToken;
- (void) setLocation: (NSMutableString*) place;
- (void) setEmail: (NSMutableString*) eAddress;
- (void) setUserBio: (NSMutableString*) bio;
- (void) setPassword:(NSMutableString *)password;
- (void) setDisplayPicturePath: (NSString *) image;
- (void) setGender:(NSMutableString *) sex;
- (void) setUpImageFromData: (NSData*) data;
- (void) setPopularity:(NSMutableString *)popularity;
- (void) incrementCount;
- (void) decrementCount;

// FriendList Methods
- (void) addFriend:(NSString *)userToAdd withEmail: (NSString *) emailAddress;
- (void) deleteFriend: (NSString *) userToRemove;
- (void) updateUserByEmail: (NSString *) emailAddress andNewName: (NSString *) currentName;



@end
