//
//  DetialViewController.h
//  Film_Reel
//
//  Created by Brayden Girard on 12/1/2013.
//  Copyright (c) 2013 Ben Sweett (100846396) and Brayden Girard (100852106). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Networking.h"

@interface DetialViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextView *name;
@property (strong, nonatomic) IBOutlet UITextView *email;
@property (strong, nonatomic) IBOutlet UIImageView *displayPicture;
@property (strong, nonatomic) IBOutlet UITextView *bio;
@property (strong, nonatomic) IBOutlet UITextView *location;
@property (strong, nonatomic) IBOutlet UIImageView *friendstar1;
@property (strong, nonatomic) IBOutlet UIImageView *friendstar2;
@property (strong, nonatomic) IBOutlet UIImageView *friendstar3;
@property (strong, nonatomic) IBOutlet UIImageView *friendstar4;
@property (strong, nonatomic) IBOutlet UIImageView *friendstar5;

@property (strong, nonatomic) NSString *friendEmail;
@property (strong, nonatomic) User* friendUser;

@property (strong, nonatomic) Networking* getProfile;
@property (strong, nonatomic) UIAlertView* error;
@property (strong, nonatomic) UIActivityIndicatorView* indicator;

@end
